Example Snakemake Projects
---

Intended to test Snakemake support on latch and provide examples for
co-development.

```
cd fgbio
cp -r latch latch_src # Copy python souce so branch is available in container
latch register . -s Snakefile
```

### Installing latch from branch

```
git checkout kenny/snakekit
pip install -e ".[snakemake]"
```
