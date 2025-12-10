pipelineJob('createPipeline_reclamation') {
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        url('https://gitlab.com/AhmedKacemTN/reclamation.git')
                        credentials('gitlab_reclamation_token')
                    }
                    branch('devops')
                }
            }
            scriptPath('devops/jenkins/Jenkinsfile.prod')
        }
    }
}
