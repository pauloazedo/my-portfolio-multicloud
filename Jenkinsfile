pipeline {
  agent any

  environment {
    ANSIBLE_INVENTORY = "ansible/inventory/hosts"
    OCIR_REPO = "iad.ocir.io/idtijq8cx4jl/uat-site"
    SSH_KEY_PATH = "/var/jenkins_home/.ssh/id_rsa"
    ANSIBLE_REMOTE_USER = "devops"
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
          def tag = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          writeFile file: 'image_tag.txt', text: tag
        }
      }
    }

    stage('Sync frontend code to UAT server') {
      steps {
        script {
          def imageTag = readFile('image_tag.txt').trim()
          env.IMAGE_TAG = imageTag

          sh '''
            set -e
            rsync -az --delete \
              -e "ssh -i ${SSH_KEY_PATH} -o StrictHostKeyChecking=accept-new" \
              ./my-portfolio/frontend/ ${ANSIBLE_REMOTE_USER}@oci.uat.pauloazedo.dev:/home/devops/frontend
          '''
        }
      }
    }

    stage('Trigger Ansible Deployment') {
      steps {
        script {
          def imageTag = readFile('image_tag.txt').trim()
          env.IMAGE_TAG = imageTag

          sh """
            set -e
            echo '[INFO] Creating Jenkins self-deployment marker'
            touch ${JENKINS_MARKER}

            export ANSIBLE_SSH_ARGS="-i ${SSH_KEY_PATH} -o StrictHostKeyChecking=accept-new"
            export ANSIBLE_REMOTE_USER=${ANSIBLE_REMOTE_USER}

            /home/jenkins/venv/bin/ansible-playbook -i ${ANSIBLE_INVENTORY} ansible/site.yml \
              --limit uat \
              --tags uat_site \
              --extra-vars "uat_site_custom_image=${OCIR_REPO}:${IMAGE_TAG} \
                            uat_site_image_tag=${IMAGE_TAG}"
          """
        }
      }

      post {
        always {
          sh 'rm -f /var/jenkins_home/.jenkins_self_deploy || true'
        }
      }
    }
  }

  post {
    success {
      script {
        def imageTag = readFile('image_tag.txt').trim()
        echo "✅ Ansible-driven UAT deployment completed for image: ${env.OCIR_REPO}:${imageTag}"
      }
    }
    failure {
      echo "❌ Pipeline failed. Check logs"
    }
  }
}