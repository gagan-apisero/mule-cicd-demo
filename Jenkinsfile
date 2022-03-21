def timeStamp = Calendar.getInstance().getTime().format('YYYYMMdd-hhmmss',TimeZone.getTimeZone('CST'))
pipeline {
  agent any
  environment {
			//this is the anypoint userID
			APP_NAME = 'jenkinsCICDTestAPI'
			
	}
  stages {
    stage('Build Application') {
			steps {
				script{
					stdout = bat( script: 'git.exe log -1 --pretty="format:Commit Message: %%s% %%%n%% Author: %%an% %%n% Date: %%aD%"' ,returnStdout: true).trim()
					env.GIT_COMMENT = (stdout.readLines().drop(1).join("\n"))
				}
				echo "GIT_COMMIT : '${env.GIT_COMMENT}'" 
				bat 'mvn clean package -Djar.name=%APP_NAME%'
				
			}
		}
    
    stage('Moving the jar'){
        steps{
            script{
                if("SUCCESS".equals(currentBuild.previousBuild.result)){
                    bat 'COPY %WORKSPACE%\\target\\*.jar C:\\zatch\\zzz /Y'
                }
            }
        }
    }

    stage('Munit test') {
      steps {
        echo 'Munit test case'
      }
    }

  stage('Deploy CloudHub') {
            environment {
                ANYPOINT_CREDENTIALS = credentials('anypoint.credentials')
                ANYPOINT_CLIENT_ID = credentials('client_id')
                ANYPOINT_CLIENT_SECRET = credentials('client_secret')
                BRANCH_NAME = "${env.GIT_BRANCH}"
            }
			steps {
				script{
                        if(env.GIT_BRANCH == "dev")  {
                            
                            echo 'Deploying mule project due to the latest code commits in Dev branch…'
                            echo 'Deploying to the Development environment.'
                            bat 'mvn deploy -DmuleDeploy -Danypoint.username=%ANYPOINT_CREDENTIALS_USR% -Danypoint.password=%ANYPOINT_CREDENTIALS_PSW% -Danypoint.platform.client_id=%ANYPOINT_CLIENT_ID% -Danypoint.platform.client_secret=%ANYPOINT_CLIENT_SECRET% -Danypoint.env=Sandbox -Danypoint.region=us-east-1 -Danypoint.workers=1 -Danypoint.name=%APP_NAME%-dev -Djar.name=%APP_NAME% -Dmule.artifact=%WORKSPACE%\\target\\%APP_NAME%-mule-application.jar'
                        }
                        
                        else if(env.GIT_BRANCH == "qa")  {
                            mail to: 'gagan.verma@apisero.com',
                            subject: "Approve QA Pipeline: ${currentBuild.fullDisplayName}",
                            body: "Please click  here  ${BUILD_URL} input to approve or reject the deployment in QA for the following GIT commment : \n\n${env.GIT_COMMENT}\n" 
                            
                            echo 'Deploying mule project due to the latest code commit in QA branch…'
                            echo 'Deploying to the QA environment.'
                            
                            timeout(time: 30, unit: 'MINUTES'){
                                input "Deploy to QA?" }
                                bat 'mvn package deploy -DmuleDeploy -Danypoint.username=%ANYPOINT_CREDENTIALS_USR% -Danypoint.password=%ANYPOINT_CREDENTIALS_PSW% -Danypoint.platform.client_id=%ANYPOINT_CLIENT_ID% -Danypoint.platform.client_secret=%ANYPOINT_CLIENT_SECRET% -Danypoint.env=Sandbox -Danypoint.region=us-east-1 -Danypoint.workers=1 -Danypoint.name=%APP_NAME%-qa'
                        }
                        
                        else if(env.GIT_BRANCH == "origin/release")  {
                            mail to: 'gagan.verma@apisero.com',
                            subject: "Approve Production Pipeline: ${currentBuild.fullDisplayName}",
                            body: "Please click  here  ${BUILD_URL} input to approve or reject the deployment in prod"
                            
                            echo 'Deploying mule project due to the latest code commit in Prod branch…'
                            echo 'Deploying to the Production environment.'
                            
                            timeout(time: 30, unit: 'MINUTES'){
                                input "Deploy to Production?"}
                                bat 'mvn package deploy -DmuleDeploy -Danypoint.username=%ANYPOINT_CREDENTIALS_USR% -Danypoint.password=%ANYPOINT_CREDENTIALS_PSW% -Danypoint.platform.client_id=%ANYPOINT_CLIENT_ID% -Danypoint.platform.client_secret=%ANYPOINT_CLIENT_SECRET% -Danypoint.env=Sandbox -Danypoint.region=us-east-1 -Danypoint.workers=1 -Danypoint.name=%APP_NAME%-prod'
                        }
                        else  {
                            echo "Branch not expected" 
                        }
                    
				}
			}
		}
	}
	post {
		failure {
			mail to: 'gagan.verma@apisero.com',
			subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
			body: "Something is wrong with ${env.BUILD_URL} and found the following git comment:\n\n${env.GIT_COMMENT}\n"
		}
		success {
			mail to: 'gagan.verma@apisero.com',
			subject: "Successful Pipeline: ${currentBuild.fullDisplayName}",
				body: "Sucessfully deployed and found the following git comment:\n\n${env.GIT_COMMENT}\n"
		}
	}
}
