#! /usr/bin/env bash

## MOLB 7621 Problem Set 2
## Extra Credit Question:
## Using bedtools jaccard, what two transcription factor binding sites 
## in encode.tfbs.chr22.bed.gz are most similar? 


# Files to be used
tfbs='/home/ubuntu/MOLB-7621/data-sets/bed/encode.tfbs.chr22.bed.gz'

# Create list of all transcription factors
zcat $tfbs | cut -f4 | sort | uniq > all_tf.txt

# Create directory for all BED files that will be created
mkdir bed_files

# Create BED file for each transcription factor
for line in `cat all_tf.txt`; do

    zcat $tfbs | awk -v var="$line" 'BEGIN {OFS="\t"} ($4 == var)' > bed_files/$line.bed

done

# Jaccard statistic for each pair of transcription factors
(
for line1 in `cat all_tf.txt`; do
    for line2 in `cat all_tf.txt`; do    

        if [ $line1 == $line2 ]; then
            continue
        fi
        
        jaccard=$(bedtools jaccard -a bed_files/$line1.bed -b bed_files/$line2.bed | tail -n1 | cut -f3)

        echo -e ''$line1'\t'$line2'\t'$jaccard''

    done

done
) > all_jac.tsv

# Print answer
sort -k3 -nr all_jac.tsv | awk '$3 !~ /e/' | head -n1
