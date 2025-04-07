pipeline {
  agent any

  environment {
    ANSIBLE_INVENTORY     = 'ansible/inventory/oci.ini'
    OCIR_REPO             = 'iad.ocir.io/idtijq8cx4jl/uat-site'
    SSH_KEY_PATH          = '/var/jenkins_home/.ssh/id_rsa'
    ANSIBLE_REMOTE_USER   = 'devops'
    ANSIBLE_TARGET_HOST   = 'oci.uat.pauloazedo.dev'
    JENKINS_MARKER        = '/var/jenkins_home/.jenkins_self_deploy'
    FRONTEND_SRC_DIR      = './my-portfolio/frontend/'
    FRONTEND_DST_DIR      = '/home/devops/frontend'
    IMAGE_TAG_FILE        = 'image_tag.txt'
    VENV_ACTIVATE         = '/home/jenkins/venv/bin/ansible-playbook'
  }

  options {
    timestamps()
    ansiColor('xterm')
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'uat', url: 'https://github.com/pauloazedo/my-portfolio-oci-devops.git'
      }
    }

    stage('Generate Image Tag') {
      steps {
        script {
          env.IMAGE_TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          writeFile file: IMAGE_TAG_FILE, text: env.IMAGE_TAG
        }
      }
    }

    stage('Sync Frontend to UAT') {
      steps {
        sh '''
          set -e
          rsync -az --delete \
            -e "ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=accept-new" \
            ${FRONTEND_SRC_DIR} ${ANSIBLE_REMOTE_USER}@${ANSIBLE_TARGET_HOST}:${FRONTEND_DST_DIR}
        '''
      }
    }

    stage('Run Ansible Deployment') {
      steps {
        withCredentials([file(credentialsId: 'ansible-vault-passfile', variable: 'VAULT_PASS_FILE')]) {
          sh '''
            set -e
            echo '[INFO] Creating Jenkins self-deployment marker'
            touch ${JENKINS_MARKER}

            export ANSIBLE_SSH_ARGS="-i ${SSH_KEY_PATH} -o StrictHostKeyChecking=accept-new"
            export ANSIBLE_REMOTE_USER=${ANSIBLE_REMOTE_USER}

            ${VENV_ACTIVATE} -i ${ANSIBLE_INVENTORY} ansible/uat.yml \
              --limit uat \
              --tags uat_site \
              --extra-vars "uat_site_custom_image=${OCIR_REPO}:${IMAGE_TAG} \
                            uat_site_image_tag=${IMAGE_TAG}" \
              --vault-password-file "${VAULT_PASS_FILE}"
          '''
        }
      }

      post {
        always {
          sh 'rm -f ${JENKINS_MARKER} || true'
        }
      }
    }
  }

  post {
    success {
      echo "✅ UAT deployment completed: ${OCIR_REPO}:${env.IMAGE_TAG}"
    }
    failure {
      echo "❌ Pipeline failed. Check the logs for troubleshooting."
    }
  }
}