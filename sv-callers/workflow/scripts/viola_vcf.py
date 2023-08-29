import os
import shutil
import viola
import argparse

parser = argparse.ArgumentParser(description='viola parser')

parser.add_argument("-in", "--vcf_in", help="Input VCF", type=str)
parser.add_argument("-out", "--vcf_out", help="Output VCF", type=str)
parser.add_argument("-c", "--caller", help="Wildcard prefix", type=str)

args = parser.parse_args()

vcf_in = args.vcf_in
vcf_out = args.vcf_out
caller = args.caller

# vcf_in = str(snakemake.input)
# vcf_out = str(snakemake.output)
# caller = str(snakemake.wildcards.prefix)
vcf_org = vcf_in + '.org'

if caller == 'gridss':
    os.rename(vcf_in, vcf_org)
    with open(vcf_in, 'w') as new:
        with open(vcf_org, 'r') as org:
            for line in org:
                # FIX INFO field: change PARID to MATEID
                new.write(line.replace('PARID', 'MATEID'))
try:
    sv = viola.read_vcf(vcf_in, variant_caller=caller).breakend2breakpoint()
    sv.to_vcf(vcf_out)
except Exception:
    shutil.copyfile(vcf_in, vcf_out)
