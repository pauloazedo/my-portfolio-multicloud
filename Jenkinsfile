pipeline {
  agent any

  environment {
    // Path to Ansible inventory file
    ANSIBLE_INVENTORY     = 'ansible/inventory/hosts'

    // OCI Container Registry (OCIR) target repo
    OCIR_REPO             = 'iad.ocir.io/idtijq8cx4jl/uat-site'

    // SSH private key path for Jenkins to connect to the UAT server
    SSH_KEY_PATH          = '/var/jenkins_home/.ssh/id_rsa'

    // Remote user to execute Ansible tasks
    ANSIBLE_REMOTE_USER   = 'devops'

    // Target host for UAT deployment
    ANSIBLE_TARGET_HOST   = 'oci.uat.pauloazedo.dev'

    // Marker file to track self-deployment status (used internally)
    JENKINS_MARKER        = '/var/jenkins_home/.jenkins_self_deploy'

    // Local frontend source directory to sync
    FRONTEND_SRC_DIR      = './my-portfolio/frontend/'

    // Destination directory on remote host
    FRONTEND_DST_DIR      = '/home/devops/frontend'

    // Filename to store git-based image tag
    IMAGE_TAG_FILE        = 'image_tag.txt'

    // Ansible playbook command (inside Jenkins virtualenv)
    VENV_ACTIVATE         = '/home/jenkins/venv/bin/ansible-playbook'
  }

  options {
    // Show timestamps on all console output lines
    timestamps()

    // Preserve color output in the Jenkins console (for Ansible, shell scripts, etc.)
    ansiColor('xterm')
  }

  stages {

    stage('Checkout') {
      steps {
        // Clone the repository's UAT branch from GitHub
        git branch: 'uat', url: 'https://github.com/pauloazedo/my-portfolio-oci-devops.git'
      }
    }

    stage('Generate Image Tag') {
      steps {
        script {
          // Generate short SHA as image tag and persist to file
          env.IMAGE_TAG = sh(
            script: "git rev-parse --short HEAD",
            returnStdout: true
          ).trim()
          writeFile file: IMAGE_TAG_FILE, text: env.IMAGE_TAG
        }
      }
    }

    stage('Sync Frontend to UAT') {
      steps {
        // Rsync frontend code to the UAT server using SSH
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
        // Trigger Ansible deployment on UAT host using generated image tag
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
                          uat_site_image_tag=${IMAGE_TAG}"
        '''
      }

      post {
        always {
          // Clean up the Jenkins marker file even if the playbook fails
          sh 'rm -f ${JENKINS_MARKER} || true'
        }
      }
    }
  }

  post {
    success {
      // Output success message with deployed image tag
      echo "✅ UAT deployment completed: ${OCIR_REPO}:${env.IMAGE_TAG}"
    }
    failure {
      // Output failure message for easier alerting/debugging
      echo "❌ Pipeline failed. Check the logs for troubleshooting."
    }
  }
}