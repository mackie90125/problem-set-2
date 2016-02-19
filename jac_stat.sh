#! /usr/bin/env bash

## MOLB 7621 Problem Set 2
## Extra Credit Question:
## Using bedtools jaccard, what transcription factor binding sites in encode.tfbs.chr22.bed.gz 
## are most similar to CTCF binding sites? 


# Files to be used
tfbs='/home/ubuntu/MOLB-7621/data-sets/bed/encode.tfbs.chr22.bed.gz'

# Create list of all transcription factors
zcat encode.tfbs.chr22.bed.gz | cut -f4 | sort | uniq > all_tf.txt

# Create bed file for CTCF binding sites
zcat $tfbs | awk 'BEGIN {OFS="\t"} ($4 == "CTCF")' > CTCF.bed

# Create directory for all BED files that will be created
mkdir bed_files


# Jaccard statistic for each transcription factor compared to CTCF
(
for line in `cat all_tf.txt`; do
    
    zcat $tfbs | awk -v var="$line" 'BEGIN {OFS="\t"} ($4 == var)' > bed_files/$line.bed

    jaccard=$(bedtools jaccard -a CTCF.bed -b bed_files/$line.bed | tail -n1 | cut -f3)

    echo -e ''$line'\tCTCF\t'$jaccard''

done
) | sort -k3 -nr > all_jac.tsv


# Answer: RAD21
# This output makes sense because CTCF gives a perfect match to CTCF (obviously),
# and CTCF and RAD21 are both involved in chromatin regulation at some level,
# so it makes sense that their binding sites would be similar
