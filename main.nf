#!/usr/bin/env nextflow

/*
################
params
################
*/


params.saveBy = 'copy'



Channel.fromFilePairs("./*_{R1,R2}.p.fastq")
        .into {  ch_in_spades }


/*
#==============================================
# spades
#==============================================
*/

process spades {
    container 'quay.io/biocontainers/spades:3.14.0--h2d02072_0'
    publishDir 'results/spades', mode: params.saveBy

    input:
    tuple genomeName, file(genomeReads) from ch_in_spades

    output:
    path """${genomeName}_scaffolds.fasta""" into ch_out_spades


    script:
    
    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t 2
    cp ${genomeName}/scaffolds.fasta ${genomeName}_scaffolds.fasta 
    """
}

