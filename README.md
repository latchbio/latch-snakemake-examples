Example Snakemake Projects
---

Intended to test Snakemake support on latch and provide examples for
co-development.

```
pip install 'latch[snakemake]'
```

[Documentation](https://docs.latch.bio/manual/snakemake.html)

## fgbio

A set of tools to analyze genomic data [developed by Fulcrum Genomics](https://github.com/fulcrumgenomics/fgbio).


`cd fgbio && latch register .  --snakefile FastqToConsensus-RnD.smk`

## sv-callers

Structural variants (SVs) are an important class of genetic variation implicated in a wide array of genetic diseases. _sv-callers_ is a _Snakemake_-based workflow that combines several state-of-the-art tools for detecting SVs in whole genome sequencing (WGS) data. The workflow is developed and maintained by [Netherlands eScience Center project: Googling the cancer genome](https://github.com/GooglingTheCancerGenome/sv-callers).

Clone the repository:
```bash
git clone https://github.com/latchbio/snakemake-sv-callers.git
````
Register the workflow with the Latch SDK:
```bash
cd snakemake-sv-callers && latch register . --snakefile workflow/Snakefile
```

## kraken2_classification

A Snakemake pipeline wrapper of the Kraken2 short read metagenomic classification software, with additional tools for analysis, plots, compositional data and differential abundance calculation. Designed and maintained by [Ben Siranosian](https://github.com/bhattlab/kraken2_classification) in [Ami Bhatt's lab](http://www.bhattlab.com/) at Stanford University. 

Clone the repository:
```bash
git clone https://github.com/latchbio/snakemake_kraken2_classification.git
```

Register the workflow with the Latch SDK:
```bash
cd snakemake_kraken2_classification && latch register . --snakefile Snakefile
```
