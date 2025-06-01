# Run QC and trimming on full dataset

# Load modules
module load FastQC/0.11.9-Java-11
module load Trimmomatic/0.39-Java-13
module load MultiQC/1.14-foss-2022a

# 1. Run FastQC on raw reads
mkdir -p data/fastqc_raw_results
fastqc -o data/fastqc_raw_results data/raw_fastq/*.fastq.gz

# Run MultiQC
multiqc -o data/fastqc_raw_results data/fastqc_raw_results

# 2. Trim raw reads
mkdir -p data/trimmed_fastq
TRIMMOMATIC="java -jar /apps/eb/Trimmomatic/0.39-Java-13/trimmomatic-0.39.jar"

for fwd in data/raw_fastq/*_1.fastq.gz
do
    sample=$(basename $fwd _1.fastq.gz)
    $TRIMMOMATIC PE \
        data/raw_fastq/${sample}_1.fastq.gz data/raw_fastq/${sample}_2.fastq.gz \
        data/trimmed_fastq/${sample}_1.paired.fastq.gz data/trimmed_fastq/${sample}_1.unpaired.fastq.gz \
        data/trimmed_fastq/${sample}_2.paired.fastq.gz data/trimmed_fastq/${sample}_2.unpaired.fastq.gz \
        ILLUMINACLIP:/apps/eb/Trimmomatic/0.39-Java-13/adapters/NexteraPE-PE.fa:2:30:10:5:TRUE SLIDINGWINDOW:4:20
done

# 3. Run FastQC and MultiQC on trimmed reads
mkdir -p data/fastqc_trimmed_results
fastqc -o data/fastqc_trimmed_results data/trimmed_fastq/*paired.fastq.gz
multiqc -o data/fastqc_trimmed_results data/fastqc_trimmed_results

