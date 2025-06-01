
set -e

# Load required modules
module load BWA/0.7.18-GCCcore-13.3.0
module load SAMtools/1.18-GCC-12.3.0
module load BCFtools/1.18-GCC-12.3.0

# 1. Download and prepare genome
mkdir -p data/genomes
genome_fasta="data/genomes/ecoli_rel606.fna"
genome_url="ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/017/985/GCA_000017985.1_ASM1798v1/GCA_000017985.1_ASM1798v1_genomic.fna.gz"

wget -O ${genome_fasta}.gz $genome_url
gunzip ${genome_fasta}.gz
bwa index $genome_fasta

# 2. Alignment and variant calling
mkdir -p results/sam results/bam results/bcf results/vcf

for fwd in data/trimmed_fastq/*_1.paired.fastq.gz
do
    sample=$(basename $fwd _1.paired.fastq.gz)
    rev=data/trimmed_fastq/${sample}_2.paired.fastq.gz

    echo "Aligning $sample"
    bwa mem $genome_fasta $fwd $rev > results/sam/$sample.sam

    echo "Converting SAM to sorted BAM"
    samtools view -S -b results/sam/$sample.sam > results/bam/$sample.bam
    samtools sort -o results/bam/$sample.sorted.bam results/bam/$sample.bam

    echo "Calling variants in $sample"
    bcftools mpileup -O b -o results/bcf/$sample.bcf -f $genome_fasta results/bam/$sample.sorted.bam
    bcftools call --ploidy 1 -m -v -o results/vcf/$sample.vcf results/bcf/$sample.bcf
done

