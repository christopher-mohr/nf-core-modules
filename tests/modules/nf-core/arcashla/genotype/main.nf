#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { ARCASHLA_EXTRACT  } from '../../../../../modules/nf-core/arcashla/extract/main.nf'
include { ARCASHLA_GENOTYPE } from '../../../../../modules/nf-core/arcashla/genotype/main.nf'

workflow test_arcashla_genotype {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['homo_sapiens']['illumina']['test_rna_paired_end_sorted_chr6_bam'], checkIfExists: true)
    ]

    ARCASHLA_EXTRACT ( input )

    ARCASHLA_GENOTYPE ( ARCASHLA_EXTRACT.out.extracted_reads_fastq )
}
