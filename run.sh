#! /usr/bin/env bash

## run.sh
## Problem Set 2 - MOLB 7621

## Files to be used

h3k4='/home/ubuntu/MOLB-7621/data-sets/bed/encode.h3k4me3.hela.chr22.bed.gz'
tfbs='/home/ubuntu/MOLB-7621/data-sets/bed/encode.tfbs.chr22.bed.gz'
genome='/home/ubuntu/MOLB-7621/data-sets/genome/hg19.genome'
tss='/home/ubuntu/MOLB-7621/data-sets/bed/tss.hg19.chr22.bed.gz'
hg19='/home/ubuntu/MOLB-7621/data-sets/fasta/hg19.chr22.fa'
ctcf='/home/ubuntu/MOLB-7621/data-sets/bedtools/ctcf.hela.chr22.bg.gz'
genes='/home/ubuntu/MOLB-7621/data-sets/bed/genes.hg19.bed.gz'



# 1. Use BEDtools intersect to identify the size of the largest overlap between CTCF and H3K4me3 locations.

ans1=$(bedtools intersect -a \
    <(zcat $tfbs | awk '$4 == "CTCF"') \
    -b $h3k4 \
    | awk '{print $3-$2}' | sort -nr | head -n1)

echo 'answer-1:' $ans1


# 2. Use BEDtools to calculate the GC content of nucleotides 19,000,000 to
# 19,000,500 on chr22 of hg19 genome build. Report the GC content as a
# fraction (e.g., 0.50)

ans2=$(bedtools nuc -fi $hg19 -bed <(echo -e "chr22\t19000000\t19000500") \
    | awk '{print $5}' | tail -n1)

echo 'answer-2:' $ans2


# 3. Use BEDtools to identify the length of the CTCF ChIP-seq peak (i.e.,
# interval) that has the largest mean signal in ctcf.hela.chr22.bg.gz.

ans3=$(bedtools map -a <(zcat $tfbs | awk '$4 == "CTCF"') \
    -b $ctcf -c 4 -o mean \
    | sort -k5 -nr | head -n1 | awk '{print $3-$2}')

echo 'answer-3:' $ans3


# 4. Use BEDtools to identify the gene promoter (defined as 1000 bp upstream of a TSS) 
# with the highest median signal in ctcf.hela.chr22.bg.gz. Report the gene name (e.g., 'ABC123')
# PRAME

ans4=$(bedtools map -a <(bedtools flank -i $tss -g $genome -l 1000 -r 0 -s | bedtools sort -i -) \
    -b $ctcf -c 4 -o median \
    | awk '$7 != "."' | sort -k7 -nr | head -n1 | awk '{print $4}')

echo 'answer-4:' $ans4


# 5. Use BEDtools to identify the longest interval on chr22 that is not
# covered by genes.hg19.bed.gz. Report the interval like chr1:100-500

ans5=$(bedtools complement -i $genes -g <(awk '$1 == "chr22"' $genome) \
    | awk '{print $0,$3-$2}' | sort -k4 -nr | head -n1 \
    | awk 'BEGIN {OFS=""} {print $1,":",$2,"-",$3}')

echo 'answer-5:' $ans5


# 6. Use one or more BEDtools that we haven't covered in class. Be creative.

echo 'answer-6:' 'See jac_stat.sh file'









