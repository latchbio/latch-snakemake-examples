rule viola:  # used by both modes
    input:
        os.path.join(
            "{path}",
            "{tumor}--{normal}",
            "{outdir}",
            "{}{}".format("{prefix}", config.file_exts.vcf),
        )
        if config.mode is config.mode.PAIRED_SAMPLE
        else os.path.join(
            "{path}",
            "{sample}",
            "{outdir}",
            "{}{}".format("{prefix}", config.file_exts.vcf),
        ),
    output:
        os.path.join(
            "{path}",
            "{tumor}--{normal}",
            "{outdir}",
            "viola",
            "{}{}".format("{prefix}", config.file_exts.vcf),
        )
        if config.mode is config.mode.PAIRED_SAMPLE
        else os.path.join(
            "{path}",
            "{sample}",
            "{outdir}",
            "viola",
            "{}{}".format("{prefix}", config.file_exts.vcf),
        ),
    conda:
        "postproc"
    threads: config.postproc.survivor.threads
    resources:
        mem_mb=config.postproc.survivor.memory,
        tmp_mb=config.postproc.survivor.tmpspace,
    shell:
        """
        /opt/conda/envs/workflow/envs/postproc/bin/python3 scripts/viola_vcf.py \
        -in "{input}" -out "{output}" -c "{wildcards.prefix}"
        """
