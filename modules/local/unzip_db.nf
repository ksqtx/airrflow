process UNZIP_DB {
    tag "unzip_db"
    label 'process_medium'
    errorStrategy 'retry'
    maxRetries 3

    conda "conda-forge::sed=4.7"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://containers.biocontainers.pro/s3/SingImgsRepo/biocontainers/v1.2.0_cv1/biocontainers_v1.2.0_cv1.img' :
        'docker.io/biocontainers/biocontainers:v1.2.0_cv1' }"

    input:
    path(archive)

    output:
    path("$unzipped")   , emit: unzipped
    path "versions.yml", emit: versions

    script:
    unzipped = archive.toString() - '.zip'
    """
    sleep 120 # give the /tmp directory time to initialize
    ls -alFh /tmp # fdo
    whoami # fdo
    groups # fdo
    unzip $archive

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        unzip: \$(echo \$(unzip -help 2>&1) | sed 's/^.*UnZip //; s/ of.*\$//')
    END_VERSIONS
    """
}
