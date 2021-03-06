# NanoGrid

The distribution is a parallel wrapper around the [Nanopolish](https://github.com/jts/nanopolish) framework The pipeline is composed of bash scripts. It requires nanopolish version >=0.10, older version may not work. If you have ultra-long reads you must have samtools version >1.5 or newer or the pipeline will not work.

The current pipeline has been designed to run on the SGE/SLURM scheduling systems and has hard-coded grid resource request parameters. You must edit nano.sh to match your grid options. It is, in principle, possible to run on other grid engines but will require editing all shell scripts to not use SGE_TASK_ID but the appropriate variable for your grid environment and editing the qsub commands in nano.sh to the appropriate commands for your grid environment.

To run the pipeline you need to:

1. You must have a working installation of Nanopolish and symlink the directory from wherever you have placed Nanopolish. You must also have a working minimap2, h5ls, and samtools in your path.

2. Run the pipeline specifying the input fasta assembly and raw reads folder. Note that only .fa extensions are currently supported.

```
sh nano.sh asm.fa raw
```

It will automatically guess whether you have event or eventless basecalled files (do not mix the two in your raw folder), extract the reads, run minimap2 to map, and call consensus. Each window generated by Nanopolish will be submitted to the grid as part of an array job. You can adjust the batch size parameter in nanopolish/scripts/nanopolish_makerange.py and nanopolish/scripts/nanopolish_merge.py up or down to adjust the number of jobs:

```
# Do not change, must match nanopolish segment lengths
SEGMENT_LENGTH = 10000

# Ok to change this
SEGMENTS_PER_BATCH = 1
```

Typically we use 500000. The pipeline is very rough and has undergone limited testing so user beware.

### CITE
If you find this pipeline useful, please cite the original Nanopolish paper:<br>
Loman NJ et. al. [A complete bacterial genome assembled de novo using only nanopore sequencing data.](http://www.nature.com/nmeth/journal/v12/n8/abs/nmeth.3444.html) Nature Methods, 2015.

and the Canu paper:<br>
Koren S et al. [Canu: scalable and accurate long-read assembly via adaptive k-mer weighting and repeat separation](https://doi.org/10.1101/gr.215087.116). Genome Research. (2017).
