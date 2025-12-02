pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Cleanup') {
            steps {
                bat '''
                    docker rm -f node_app mysql_db adminer 2>nul || echo Contenedores no existentes
                    docker-compose down --remove-orphans --volumes 2>nul || echo No compose previo
                '''
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Construir sin cache para evitar problemas
                    bat 'docker build --no-cache -t crudjs-app .'
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    // Crear red para los contenedores
                    bat 'docker network create crud-network 2>nul || echo Red ya existe'
                    
                    // Iniciar MySQL
                    bat '''
                        docker run -d --name mysql_db \
                            --network crud-network \
                            -e MYSQL_ROOT_PASSWORD=root123 \
                            -e MYSQL_DATABASE=cruddb \
                            -p 3306:3306 \
                            mysql:8
                    '''
                    
                    // Esperar a que MySQL esté listo
                    bat 'timeout /t 30 /nobreak'
                    
                    // Ejecutar tests dentro del contenedor
                    bat '''
                        docker run --rm \
                            --network crud-network \
                            -e DB_HOST=mysql_db \
                            -e DB_USER=root \
                            -e DB_PASSWORD=root123 \
                            -e DB_NAME=cruddb \
                            crudjs-app \
                            npm test
                    '''
                }
            }
            post {
                always {
                    // Limpiar contenedores de test
                    bat 'docker stop mysql_db 2>nul && docker rm mysql_db 2>nul'
                }
            }
        }
        
        stage('Deploy') {
            steps {
                bat '''
                    docker-compose up -d
                    echo "Aplicación desplegada en http://localhost:3000"
                '''
            }
        }
    }
    
    post {
        always {
            // Archivar resultados
            junit '**/test-results.xml'
            // Publicar reportes si existen
            publishHTML(target: [
                reportDir: 'coverage',
                reportFiles: 'index.html', 
                reportName: 'Coverage Report'
            ])
        }
        
        failure {
            echo 'Pipeline falló - Revisar logs'
        }
    }
}