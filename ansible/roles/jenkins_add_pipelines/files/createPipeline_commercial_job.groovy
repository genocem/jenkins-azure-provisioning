pipelineJob('createPipeline_commercial') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://gitlab.com/AhmedKacemTN/stage_devops.git')
                        credentials('gitlab_stageDevops_commercial_token')
                    }
                    branch('devops')
                }
            }
            scriptPath('devops/jenkins/Jenkinsfile.dev')
        }
    }
}
