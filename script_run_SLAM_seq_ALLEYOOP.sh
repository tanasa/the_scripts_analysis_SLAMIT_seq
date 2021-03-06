#!/bin/bash

################################################################################################

module load legacy/scg4
module load r/3.6

################################################################################################ 
################################################################################################ 
################################################################################################
# FILE=$1

FILE="Sample-2_R1_001.fastq_slamdunk_mapped_filtered.bam"

TSV="Sample-2_R1_001.fastq_slamdunk_mapped_filtered_tcount.tsv"

BED="GSE99970_GSE99970_mESC_counting_windows.downloaded.GSE99970.03sep2020.bed"

FASTA="GRCm38.primary_assembly.genome.fa"

################################################################################################ dedup
################################################################################################

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop dedup \
-o "${FILE%.bam}.alleyoop.dedup" \
-t 8 \
$FILE

################################################################################################ collapse
################################################################################################

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop collapse \
-o "${TSV%.tsv}.alleyoop.collapse" \
-t 8 \
$TSV

################################################################################################ RATES
################################################################################################
################################################################################################ adjust MQ

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop rates \
-o "${FILE%.bam}.alleyoop.rates" \
-r $FASTA \
-t 8 \
$FILE

################################################################################################ tccontext
################################################################################################
################################################################################################ adjust MQ

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop tccontext \
-o "${FILE%.bam}.alleyoop.tccontext" \
-r $FASTA \
-t 8 \
$FILE

################################################################################################
################################################################################################
################################################################################################ utrrates

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop utrrates \
-o "${FILE%.bam}.alleyoop.utrrates" \
-r $FASTA \
-b $BED \
-t 8 \
$FILE

################################################################################################
################################################################################################
################################################################################################ SNPEVAL
############## we have to copy the VCF file in the current folder !

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop snpeval \
-s . \
-o "${FILE%.bam}.alleyoop.snpeval" \
-r $FASTA \
-b $BED \
-t 8 \
$FILE

################################################################################################
################################################################################################ SUMMARY
############## positional arguments:
############## we have to copy the TSV file in the current folder !

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop summary \
-o "${FILE%.bam}.alleyoop.summary" \
-t . \
$FILE

################################################################################################
################################################################################################
################################################################################################ tcperreadpos

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop tcperreadpos \
-o "${FILE%.bam}.alleyoop.tcperreadpos" \
-s . \
-r $FASTA \
-t 8 \
$FILE

################################################################################################
################################################################################################
################################################################################################ tcperutrpos

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop tcperutrpos \
-o "${FILE%.bam}.alleyoop.tcperutrpos" \
-r $FASTA \
-b $BED \
-s . \
-t 8 \
$FILE

################################################################################################
################################################################################################
################################################################################################ dump

singularity exec ../SLAMDUNK_SINGULARITY/slamdunk_latest.sif alleyoop dump \
-o "${FILE%.bam}.alleyoop.dump" \
-r $FASTA \
-s . \
-t 8 \
$FILE

################################################################################################
################################################################################################
################################################################################################
