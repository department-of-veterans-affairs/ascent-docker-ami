@Library('ascent') _

packerPipeline {
    directory = 'packer'
    packerFile = 'docker.json'
    vars = [
        aws_region: 'us-gov-west-1',
        image_type: 'Manager'
    ]
}

packerPipeline {
    directory = 'packer'
    packerFile = 'docker.json'
    vars = [
        aws_region: 'us-gov-west-1',
        image_type: 'Worker'
    ]
}