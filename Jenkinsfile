pipeline {
  agent any

  environment {
    ANSIBLE_INVENTORY = "ansible/inventory/hosts"
    OCIR_REPO = "iad.ocir.io/idtijq8cx4jl/uat-site"
    IMAGE_TAG = ""
  }

  options {
    timestamps()
    ansiColor('xterm')
  }

  triggers {
    pollSCM('H/5 * * * *')
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'uat',
            url: 'https://github.com/pauloazedo/my-portfolio-oci-devops.git'
      }
    }

    stage('Set Image Tag') {
      steps {
        script {
          IMAGE_TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = IMAGE_TAG
        }
      }
    }

    stage('Sync frontend code to UAT server') {
      steps {
        sh '''
          rsync -az --delete ./my-portfolio/frontend/ devops@uat.pauloazedo.us:/home/devops/frontend
        '''
      }
    }

    stage('Trigger Ansible Deployment') {
      steps {
        sh """
          ansible-playbook -i ${ANSIBLE_INVENTORY} ansible/site.yml \
            --limit uat \
            --extra-vars "uat_site_custom_image=${OCIR_REPO}:${IMAGE_TAG} \
                          uat_site_image_tag=${IMAGE_TAG}"
        """
      }
    }
  }

  post {
    success {
      echo "✅ Ansible-driven UAT deployment completed for image: ${OCIR_REPO}:${IMAGE_TAG}"
    }
    failure {
      echo "❌ Pipeline failed. Check logs"
    }
  }
}