@Library('ascent') _

packerPipeline {
    packerFile = 'docker.json'
    vars = [
        aws_region: 'us-gov-west-1',
        image_type: 'Manager'
    ]
}

packerPipeline {
    packerFile = 'docker.json'
    vars = [
        aws_region: 'us-gov-west-1',
        image_type: 'Worker'
    ]
}