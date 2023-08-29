from pathlib import Path

from latch.types.directory import LatchDir
from latch.types.file import LatchFile
from latch.types.metadata import LatchAuthor, SnakemakeFileParameter, SnakemakeMetadata

SnakemakeMetadata(
    display_name="fgbio Best Practise FASTQ -> Consensus Pipeline",
    author=LatchAuthor(
        name="Fulcrum Genomics",
    ),
    parameters={
        "r1_fastq": SnakemakeFileParameter(
            display_name="Read 1 FastQ",
            type=LatchFile,
            path=Path("r1.fq.gz"),
        ),
        "r2_fastq": SnakemakeFileParameter(
            display_name="Read 2 FastQ",
            type=LatchFile,
            path=Path("r2.fq.gz"),
        ),
        "genome": SnakemakeFileParameter(
            display_name="Reference Genome",
            type=LatchDir,
            path=Path("ref_genome"),
        ),
    },
)
