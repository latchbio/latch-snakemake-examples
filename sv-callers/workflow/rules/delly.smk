rule delly_p:  # paired-samples analysis
    input:
        fasta=get_fasta(),
        fai=get_faidx()[0],
        tumor_bam=get_bam("{path}/{tumor}"),
        tumor_bai=get_bai("{path}/{tumor}"),
        normal_bam=get_bam("{path}/{normal}"),
        normal_bai=get_bai("{path}/{normal}"),
        excl_opt=get_bed()
    params:
        excl_opt='-x "%s"' % get_bed() if exclude_regions() else "",
    output:
        bcf = os.path.join(
            "{path}",
            "{tumor}--{normal}",
            get_outdir("delly"),
            "delly-{}{}".format("{sv_type}", config.file_exts.bcf),
        ),
        bcf_index = os.path.join(
            "{path}",
            "{tumor}--{normal}",
            get_outdir("delly"),
            "delly-{}{}".format("{sv_type}", config.file_exts.bcf),
        ) + ".csi"
    conda:
        "caller"
    threads: config.callers.delly.threads
    resources:
        mem_mb=config.callers.delly.memory,
        tmp_mb=config.callers.delly.tmpspace,
    shell:
        """
        set -xe

        OUTDIR="$(dirname "{output.bcf}")"
        PREFIX="$(basename "{output.bcf}" .bcf)"
        OUTFILE="${{OUTDIR}}/${{PREFIX}}.unfiltered.bcf"
        TSV="${{OUTDIR}}/sample_pairs.tsv"

        # fetch sample ID from a BAM file
        function get_samp_id() {{
            echo "$(samtools view -H ${{1}} | \
                   perl -lne 'print ${{1}} if /\sSM:(\S+)/' | \
                   head -n 1)"
        }}

        # run dummy or real job
        if [ "{config.echo_run}" -eq "1" ]; then
            echo "{input}" > "{output.bcf}"
        else
            # use OpenMP for threaded jobs
            export OMP_NUM_THREADS={threads}
            #export OMP_PROC_BIND=true
            #export OMP_PLACES=threads

            # SV calling
            delly call \
                -t "{wildcards.sv_type}" \
                -g "{input.fasta}" \
                -o "${{OUTFILE}}" \
                -q 1 `# min.paired-end mapping quality` \
                -s 9 `# insert size cutoff, DELs only` \
                {params.excl_opt} \
                "{input.tumor_bam}" "{input.normal_bam}"
            # somatic + SV quality filtering
            #   create sample list
            TID=$(get_samp_id "{input.tumor_bam}")
            CID=$(get_samp_id "{input.normal_bam}")
            printf "${{TID}}\ttumor\n${{CID}}\tcontrol\n" > ${{TSV}}
            delly filter \
                -f somatic \
                -t "{wildcards.sv_type}" \
                -p \
                -s "${{TSV}}" \
                -o "{output.bcf}" \
                "${{OUTFILE}}"
        fi
        """


rule delly_s:  # single-sample analysis
    input:
        fasta=get_fasta(),
        fai=get_faidx()[0],
        bam=get_bam("{path}/{sample}"),
        bai=get_bai("{path}/{sample}"),
        excl_opt=get_bed()
    params:
        excl_opt='-x "%s"' % get_bed() if exclude_regions() else "",
    output:
        bcf = os.path.join(
            "{path}",
            "{sample}",
            get_outdir("delly"),
            "delly-{}{}".format("{sv_type}", config.file_exts.bcf),
        ),
        bcf_index = os.path.join(
            "{path}",
            "{sample}",
            get_outdir("delly"),
            "delly-{}{}".format("{sv_type}", config.file_exts.bcf),
        ) + ".csi"
    conda:
        "caller"
    threads: 1
    resources:
        mem_mb=config.callers.delly.memory,
        tmp_mb=config.callers.delly.tmpspace,
    shell:
        """
        set -xe

        OUTDIR="$(dirname "{output.bcf}")"
        PREFIX="$(basename "{output.bcf}" .bcf)"
        OUTFILE="${{OUTDIR}}/${{PREFIX}}.unfiltered.bcf"

        # run dummy or real job
        if [ "{config.echo_run}" -eq "1" ]; then
            echo "{input}" > "{output}"
        else
            # use OpenMP for threaded jobs
            export OMP_NUM_THREADS={threads}

            # SV calling
            delly call \
                -t "{wildcards.sv_type}" \
                -g "{input.fasta}" \
                -o "${{OUTFILE}}" \
                -q 1 `# min.paired-end mapping quality` \
                -s 9 `# insert size cutoff, DELs only` \
                {params.excl_opt} \
                "{input.bam}"
            # SV quality filtering
            bcftools filter \
                -O b `# compressed BCF format` \
                -o "{output.bcf}" \
                -i "FILTER == 'PASS'" \
                "${{OUTFILE}}"
            # index BCF file
            bcftools index "{output.bcf}"
        fi
        """


rule delly_merge:  # used by both modes
    input:
        bcf = [
            os.path.join(
                "{path}",
                "{tumor}--{normal}",
                get_outdir("delly"),
                "delly-{}{}".format(sv, config.file_exts.bcf),
            )
            for sv in config.callers.delly.sv_types
        ]
        if config.mode is config.mode.PAIRED_SAMPLE
        else [
            os.path.join(
                "{path}",
                "{sample}",
                get_outdir("delly"),
                "delly-{}{}".format(sv, config.file_exts.bcf),
            )
            for sv in config.callers.delly.sv_types
        ],
        bcf_index = [
            os.path.join(
                "{path}",
                "{tumor}--{normal}",
                get_outdir("delly"),
                "delly-{}{}".format(sv, config.file_exts.bcf),
            ) + ".csi"
            for sv in config.callers.delly.sv_types
        ]
        if config.mode is config.mode.PAIRED_SAMPLE
        else [
            os.path.join(
                "{path}",
                "{sample}",
                get_outdir("delly"),
                "delly-{}{}".format(sv, config.file_exts.bcf),
            ) + ".csi"
            for sv in config.callers.delly.sv_types
        ]
    output:
        os.path.join(
            "{path}",
            "{tumor}--{normal}",
            get_outdir("delly"),
            "delly{}".format(config.file_exts.vcf),
        )
        if config.mode is config.mode.PAIRED_SAMPLE
        else os.path.join(
            "{path}",
            "{sample}",
            get_outdir("delly"),
            "delly{}".format(config.file_exts.vcf),
        ),
    conda:
        "caller"
    threads: 1
    resources:
        mem_mb=1024,
        tmp_mb=0,
    shell:
        """
         set -x

         # run dummy or real job
         if [ "{config.echo_run}" -eq "1" ]; then
             cat {input} > "{output}"
         else
             # concatenate rather than merge BCF files
             bcftools concat \
                -a `# allow overlaps` \
                -O v `# uncompressed VCF format` \
                -o "{output}" \
                {input.bcf}
        fi
        """
