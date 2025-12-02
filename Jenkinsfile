pipeline {
    agent any
    
    stages {
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
                    docker network create crud-network 2>nul || echo Red ya existe
                    docker run -d --name mysql_db --network crud-network -e MYSQL_ROOT_PASSWORD=Datos2025 -e MYSQL_DATABASE=Prueba01 -p 3306:3306 mysql:8
                    timeout /t 15 /nobreak
                    docker run -d --name node_app --network crud-network -e DB_HOST=mysql_db -e DB_USER=root -e DB_PASSWORD=Datos2025 -e DB_NAME=Prueba01 -p 3000:3000 crudjs-app
                '''
            }
        }
    }
}