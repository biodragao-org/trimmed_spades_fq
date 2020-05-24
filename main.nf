Channel.fromFilePairs("./*_{R1,R2}.p.fastq")
        .into {  ch_in_spades }


/*
#==============================================
# spades
#==============================================
*/

process spades {
    container 'quay.io/biocontainers/spades:3.14.0--h2d02072_0'
    publishDir 'results/spades'

    input:
    tuple genomeName, file(genomeReads) from ch_in_spades

    output:
    path """${genomeName}""" into ch_out_spades


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${fq_1} --pe1-2 ${fq_2} -o ${genomeName} -t 2
    """
}
