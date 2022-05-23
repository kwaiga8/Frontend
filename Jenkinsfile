def imageName="192.168.44.44:8082/docker_registry/frontend"
def dockerRegistry="https://192.168.44.44:8082"
def registryCredentials="artifactory"
def dockerTag=""


pipeline{
  agent{
    label 'agent'
  }
  environment{
      scannerHome = tool 'SonarQube'
      
  }
  stages {
    stage('Elo'){
      steps{
        echo 'Hello Universe'
      }
    }
    stage('checkout repo '){
      steps{
        git branch: 'main', url: 'https://github.com/kwaiga8/Frontend.git'
      }
    }
    stage('testy'){
      steps{
        sh 'pip install -r requirements.txt'
        sh 'python3 -m pytest --cov=. --cov-report xml:test-results/coverage.xml --junitxml=test-results/pytest-report.xml'
      }
    }
    
stage('SonarQube'){
      steps{
     withSonarQubeEnv('Sonarqube') {
    // some block
    sh '${scannerHome}/bin/sonar-scanner'
}
  timeout(time: 1, unit: 'MINUTES'){
    waitForQualityGate abortPipeline:true
}
      }
    }
    stage('Build application image') {
            steps {
                script {
                  // Prepare basic image for application
                  dockerTag = "RC-${env.BUILD_ID}.${env.GIT_COMMIT.take(7)}"
                  applicationImage = docker.build("$imageName:$dockerTag",".")
                }
            }
        }
    stage('Pshing image to Artifactory') {
            steps {
                script {
                  docker.withRegistry("$dockerRegistry", "$registryCredentials"){
                      applicationImage.push()
                      applicationImage.push('latest')
                  }
                }
            }
        }
    post {
        always{
            junit testResults: "test-results/*.xml"
            cleanWs()
        }
    }
    
    
    
  }
}