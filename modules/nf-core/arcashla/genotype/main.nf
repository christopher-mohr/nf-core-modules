process ARCASHLA_GENOTYPE {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::arcas-hla=0.5.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/arcas-hla:0.5.0--hdfd78af_1':
        'quay.io/biocontainers/arcas-hla:0.5.0--hdfd78af_1' }"

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.alignment.p")   , emit: alignment
    tuple val(meta), path("*.genes.json")    , emit: genes
    tuple val(meta), path("*.genotype.json") , emit: genotype
    path "*.log"                             , emit: log
    path "versions.yml"                      , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def single_end  = meta.single_end ? "--single" : ""
    def VERSION = "0.5.0" // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.

    //arcasHLA reference --version 3.46.0 -v
    //arcasHLA reference --rebuild -v

    """
    arcasHLA reference --version 3.34.0 -v

    arcasHLA \\
        genotype \\
        $args \\
        -t $task.cpus \\
        -o . \\
        --temp temp_files/ \\
        --log ${prefix}.log \\
        $single_end \\
        $reads

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        arcashla: $VERSION
    END_VERSIONS
    """
}
