#!/usr/bin/env bash

######################################################################
#  PUBLIC DOMAIN NOTICE
#
#  This software is "United States Government Work" under the terms of the United
#  States Copyright Act. It was written as part of the authors' official duties
#  for the United States Government and thus cannot be copyrighted. This software
#  is freely available to the public for use without a copyright
#  notice. Restrictions cannot be placed on its present or future use.
#
#  Although all reasonable efforts have been taken to ensure the accuracy and
#  reliability of the software and associated data, the National Human Genome
#  Research Institute (NHGRI), National Institutes of Health (NIH) and the
#  U.S. Government do not and cannot warrant the performance or results that may
#  be obtained by using this software or data. NHGRI, NIH and the U.S. Government
#  disclaim all warranties as to performance, merchantability or fitness for any
#  particular purpose.
#
#  Please cite the authors in any work or product based on this material.
######################################################################

ASM=`cat asm`
PREFIX=`cat prefix`
SCRIPT_PATH=`cat scripts`
RAW=`cat readsraw`

if [ -e readsextracted ]; then
   READS=`cat readsextracted`
fi

if [ x$READS != "x" ] && [ -e $READS ]; then
   echo "Already done"
else
   fast5File=`find -L $RAW -name *.fast5 |head -n 1`
   eventless=`$SCRIPT_PATH/nanopolish/hdf5-1.8.14/tools/h5ls/h5ls -r $fast5File |grep -c "event_detection" |awk '{if ($1 <= 0) print "1"; else print "0"; }'`
   text="with"
   if [ $eventless -eq 1 ]; then
      text="without"
   fi

   echo "Using $fast5File determined that basecalling was done $text event calling"
   if [ $eventless -eq 1 ]; then
      # make a single fastq file and index it
      cat `find -L $RAW -name *.fastq` > reads.fastq
      $SCRIPT_PATH/nanopolish/nanopolish index -d $RAW reads.fastq && echo "reads.fastq" > readsextracted && touch extracted.success
   else
      # extract and index the fastq
      $SCRIPT_PATH/nanopolish/nanopolish extract -r -q -o reads.fastq $RAW && echo "reads.fastq" > readsextracted && touch extracted.success
   fi
fi
