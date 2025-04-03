pipeline {
  agent any

  environment {
    ANSIBLE_INVENTORY = "ansible/inventory/hosts"
    OCIR_REPO = "iad.ocir.io/idtijq8cx4jl/uat-site"
    IMAGE_TAG = ""
    ANSIBLE_REMOTE_USER = "devops"
    SSH_KEY_PATH = "/var/jenkins_home/.ssh/id_rsa"
    JENKINS_MARKER = "/var/jenkins_home/.jenkins_self_deploy"
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
          def shortCommit = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = shortCommit
        }
      }
    }

    stage('Sync frontend code to UAT server') {
      steps {
        sh '''
          set -e
          rsync -az --delete \
            -e "ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=accept-new" \
            ./my-portfolio/frontend/ ${ANSIBLE_REMOTE_USER}@oci.uat.pauloazedo.dev:/home/devops/frontend
        '''
      }
    }

    stage('Trigger Ansible Deployment') {
      steps {
        sh '''
          set -e
          echo "[INFO] Creating Jenkins self-deployment marker"
          touch ${JENKINS_MARKER}

          export ANSIBLE_SSH_ARGS="-i ${SSH_KEY_PATH} -o StrictHostKeyChecking=accept-new"
          export ANSIBLE_REMOTE_USER=${ANSIBLE_REMOTE_USER}

          /home/jenkins/venv/bin/ansible-playbook \
            -i ${ANSIBLE_INVENTORY} ansible/site.yml \
            --limit uat \
            --tags uat_site \
            --extra-vars "uat_site_custom_image=${OCIR_REPO}:${IMAGE_TAG} uat_site_image_tag=${IMAGE_TAG}"
        '''
      }
      post {
        always {
          sh '''
            echo "[INFO] Cleaning up Jenkins self-deployment marker"
            rm -f ${JENKINS_MARKER}
          '''
        }
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