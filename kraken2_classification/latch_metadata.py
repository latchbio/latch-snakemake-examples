from pathlib import Path
from latch.types.metadata import SnakemakeMetadata, SnakemakeFileParameter
from latch.types import LatchFile, LatchDir
from latch.types.metadata import LatchAuthor, LatchMetadata

SnakemakeMetadata(
    display_name="kraken2 snakemake",
    author=LatchAuthor(
            name="latchbio",
    ),
    parameters={
        "sample_reads_file": SnakemakeFileParameter(
            display_name="sample_reads_file",
            type=LatchFile,
            path=Path("tests/test_input/classification_input_pe.tsv")   
        ),
        "sample_groups_file": SnakemakeFileParameter(
            display_name="sample_groups_file",
            type=LatchFile,
            path=Path("tests/test_input/sample_groups.tsv")   
        ),
        "outdir": SnakemakeFileParameter(
            display_name="outdir",
            type=LatchDir,
            path=Path("tests/test_output/pe")
        ),
        # "database": SnakemakeFileParameter(
        #     display_name="database",
        #     type=LatchDir,
        #     path=Path("tests/db")
        # ),
        "database_taxo_k2d": SnakemakeFileParameter(
            display_name="taxo.k2d",
            type=LatchFile,
            path=Path("tests/db/taxo.k2d")
        ),
        "test_data": SnakemakeFileParameter(
            display_name="test_data",
            type=LatchDir,
            path=Path("tests/test_data")
        )
    }
)
