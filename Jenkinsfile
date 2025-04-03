pipeline {
  agent any

  environment {
    ANSIBLE_BIN = "/home/jenkins/venv/bin/ansible-playbook"
    ANSIBLE_INVENTORY = "ansible/inventory/hosts"
    OCIR_REPO = "iad.ocir.io/idtijq8cx4jl/uat-site"
    IMAGE_TAG = ""
    SSH_KEY = "/var/jenkins_home/.ssh/id_rsa"
    SSH_USER = "devops"
    SSH_HOST = "oci.uat.pauloazedo.dev"
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
          def tag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = tag
        }
      }
    }

    stage('Sync frontend code to UAT server') {
      steps {
        sh '''
          rsync -az --delete \
            -e "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=accept-new" \
            ./my-portfolio/frontend/ \
            ${SSH_USER}@${SSH_HOST}:/home/devops/frontend
        '''
      }
    }

    stage('Trigger Ansible Deployment') {
      steps {
        sh '''
          export ANSIBLE_SSH_ARGS="-i ${SSH_KEY} -o StrictHostKeyChecking=accept-new"
          export ANSIBLE_REMOTE_USER=${SSH_USER}
          ${ANSIBLE_BIN} -i ${ANSIBLE_INVENTORY} ansible/site.yml \
            --limit uat \
            --extra-vars "uat_site_custom_image=${OCIR_REPO}:${IMAGE_TAG} \
                          uat_site_image_tag=${IMAGE_TAG}"
        '''
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