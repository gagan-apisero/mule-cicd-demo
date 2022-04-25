def mvn_project_version(pom_file) {
    return sh(
        script: """mvn -N -f $pom_file org.apache.maven.plugins:maven-help-plugin:evaluate -Dexpression=project.version |
                   grep -Ev '(^\\s*\\[|Download\\w+:)'""",
        returnStdout: true).trim()
}
pipeline {
  agent any
   environment{
        VERSION = mvn_project_version("pom.xml")
    }
  stages {
    stage('Pre Stage'){
      steps {
//         pom_version = readMavenPom().getVersion()
           echo "${env.GIT_BRANCH}"
           echo "pom_version= ${VERSION}"
//         echo "pom_version=${pom_version}" 
      }
    }
    stage('Build Application') {
      steps {
        bat 'git --version'
        bat 'mvn --version'
        bat 'mvn clean install'
      }
    }
    stage('Munit test') {
      steps {
        echo 'Munit test case'
      }
    }
    stage('Updating pom version') {
      when {  
        branch 'qa'
      }
      steps {
        echo 'working on it'
        echo 'only for qa'
      }
    }
    stage('Deploy CloudHub') {
      environment {
//         ANYPOINT_CREDENTIALS = credentials('anypoint.credentials')
//         ANYPOINT_CLIENT_ID = credentials('client_id')
//         ANYPOINT_CLIENT_SECRET = credentials('client_secret')
        BRANCH_NAME = "${env.GIT_BRANCH}"
      }
      steps {
        echo 'Deploying mule project due to the latest code commit.'
        echo 'Deploying to the configured environment.'
//         bat 'mvn package deploy -DmuleDeploy -Danypoint.username=%ANYPOINT_CREDENTIALS_USR% -Danypoint.password=%ANYPOINT_CREDENTIALS_PSW% -Danypoint.platform.client_id=%ANYPOINT_CLIENT_ID% -Danypoint.platform.client_secret=%ANYPOINT_CLIENT_SECRET% -Danypoint.env=Sandbox -Danypoint.region=us-east-1 -Danypoint.workers=1 -Danypoint.name=cicd-%BRANCH_NAME%'
      }
    }
  }
}
