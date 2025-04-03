pipeline {
  agent any

  environment {
    OCIR_REPO = "iad.ocir.io/idtijq8cx4jl/uat-site"
    ANSIBLE_INVENTORY = "ansible/inventory/hosts"
    IMAGE_TAG = ""
  }

  options {
    timestamps()
    ansiColor('xterm')
  }

  triggers {
    pollSCM('H/5 * * * *') // Optional fallback to detect changes every 5 minutes
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
          // Short SHA for image tagging
          IMAGE_TAG = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
          env.IMAGE_TAG = IMAGE_TAG
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        dir('my-portfolio/frontend') {
          sh 'npm install'
        }
      }
    }

    stage('Build Next.js App') {
      steps {
        dir('my-portfolio/frontend') {
          sh 'npm run build'
        }
      }
    }

    stage('Build Docker Image') {
      steps {
        dir('my-portfolio/frontend') {
          sh "docker build -t ${OCIR_REPO}:${IMAGE_TAG} ."
        }
      }
    }

    stage('Push to OCIR') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'ocir-creds', usernameVariable: 'OCIR_USER', passwordVariable: 'OCIR_TOKEN')]) {
          sh """
            echo "${OCIR_TOKEN}" | docker login iad.ocir.io -u "${OCIR_USER}" --password-stdin
            docker push ${OCIR_REPO}:${IMAGE_TAG}
          """
        }
      }
    }

    stage('Deploy to UAT') {
      steps {
        sh """
          ansible-playbook -i ${ANSIBLE_INVENTORY} ansible/site.yml \
            --limit uat \
            --extra-vars "uat_site_custom_image=${OCIR_REPO}:${IMAGE_TAG}"
        """
      }
    }
  }

  post {
    success {
      echo "✅ UAT deployment completed for image: ${OCIR_REPO}:${IMAGE_TAG}"
    }
    failure {
      echo "❌ Pipeline failed. Check previous logs."
    }
  }
}// test trigger
