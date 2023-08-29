from pathlib import Path
from latch.types.metadata import SnakemakeMetadata, SnakemakeFileParameter
from latch.types import LatchFile, LatchDir
from latch.types.metadata import LatchAuthor, LatchMetadata

SnakemakeMetadata(
    display_name="sv-callers test",
    author=LatchAuthor(
            name="latchbio",
    ),
    parameters={
        "fasta": SnakemakeFileParameter(
            display_name="fasta",
            type=LatchDir,
            path=Path("/root/workflow/data/fasta")   
        ),
        "exclusion_list": SnakemakeFileParameter(
            display_name="exclusion_list",
            type=LatchFile,
            path=Path("/root/workflow/data/ENCFF001TDO.bed")
        ),
        "samples": SnakemakeFileParameter(
            display_name="samples",
            type=LatchFile,
            path=Path("/root/workflow/samples.csv")
        ),
        "bam": SnakemakeFileParameter(
            display_name="bam",
            type=LatchDir,
            path=Path("/root/workflow/data/bam")
        )
    }
)
