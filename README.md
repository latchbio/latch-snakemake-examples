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
