#!/bin/bash


##### Downloading data

# Assembly
curl --output ../data/maripaludis_S2.fasta.gz --remote-time ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/011/585/GCA_000011585.1_ASM1158v1/GCA_000011585.1_ASM1158v1_genomic.fna.gz
gzip -d ../data/maripaludis_S2.fasta.gz

# Annotation
curl --output ../data/maripaludis_S2.gff.gz --remote-time ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/011/585/GCA_000011585.1_ASM1158v1/GCA_000011585.1_ASM1158v1_genomic.gff.gz
gzip -d ../data/maripaludis_S2.gff.gz

# SAM file
curl --output ../data/maripaludis_S2_tnseq.zip https://www.cmbl.uga.edu//downloads/programs/Tn_seq_Explorer/Sample_input_data_Methanococcus_maripaludis_S2.zip
unzip -d ../data/ -j ../data/maripaludis_S2_tnseq.zip -x Sample_input_data/MutantLibraryA.sam
rm ../data/maripaludis_S2_tnseq.zip

# 
input_sam="../data/MutantLibraryB.sam"

fastq_name=$(basename ${input_sam} | sed 's/.sam$/.fastq/')
echo ${fastq_name}
out_dir="../output/fastq/"

if [ ! -d ${out_dir} ]; then mkdir ${out_dir}; fi

time cat ${input_sam} | grep -v "^@" | awk '{print "@"$1"\n"$10"\n+\n"$11}' > ${out_dir}${fastq_name}
gzip ${out_dir}${fastq_name}
rm ${input_sam}