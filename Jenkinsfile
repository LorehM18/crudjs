pipeline {
    agent any
    
    stages {
        stage('Clean') {
            steps {
                bat '''
                    docker stop node_app mysql_db 2>nul
                    docker rm node_app mysql_db 2>nul
                    docker network rm crud-network 2>nul
                '''
            }
        }
        
        stage('Build') {
            steps {
                bat 'docker build -t crudjs-app .'
            }
        }
        
        stage('Test') {
            steps {
                bat 'npm test'
            }
        }
        
        stage('Deploy') {
            steps {
                bat '''
                    docker network create crud-network
                    docker run -d --name mysql_db --network crud-network -e MYSQL_ROOT_PASSWORD=Datos2025 -e MYSQL_DATABASE=Prueba01 -p 3306:3306 mysql:8
                    timeout /t 15 /nobreak
                    docker run -d --name node_app --network crud-network -e DB_HOST=mysql_db -e DB_USER=root -e DB_PASSWORD=Datos2025 -e DB_NAME=Prueba01 -p 3000:3000 crudjs-app
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline exitoso!'
        }
        failure {
            echo '❌ Pipeline falló'
        }
    }
}