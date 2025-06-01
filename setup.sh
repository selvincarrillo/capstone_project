# Script to set up analysis of E coli variation

# Make subdirectories
mkdir -p data docs results

# Copy over full raw fastq files
cp -r /work/binf8960/instructor_data/raw_fastq/ ./data/

# Make the raw data read-only
chmod -R a-w data/raw_fastq/

