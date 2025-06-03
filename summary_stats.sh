set -e

module load SAMtools/1.18-GCC-12.3.0

# Create results directory if it doesn't exist
#mkdir -p results

# Output file
summary_file="results/summary_stats.tsv"

# Header
echo -e "sample\traw_reads\ttrimmed_reads\taligned_reads\tvariant_sites" > $summary_file

# Loop over samples
for fwd in data/raw_fastq/*_1.fastq.gz
do
    sample=$(basename $fwd _1.fastq.gz)

    # Count raw reads (each read = 4 lines in FASTQ)
    raw_reads=$(zcat data/raw_fastq/${sample}_1.fastq.gz | echo $((`wc -l` / 4)))

    # Count trimmed paired reads (forward only; assumes forward/reverse are paired equally)
    trimmed_reads=$(zcat data/trimmed_fastq/${sample}_1.paired.fastq.gz | echo $((`wc -l` / 4)))

    # Count aligned reads from BAM (only reads that aligned)
    aligned_reads=$(samtools view -c -F 0x4 results/bam/${sample}.sorted.bam)

    # Count variant sites (non-header lines in VCF)
    variant_sites=$(grep -vc "^#" results/vcf/${sample}.vcf)

    # Output in tidy format
    echo -e "${sample}\t${raw_reads}\t${trimmed_reads}\t${aligned_reads}\t${variant_sites}" >> $summary_file
done

