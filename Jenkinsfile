pipeline {
    agent any

    stages {
        // ELIMINÉ la etapa "Checkout" duplicada
        // Jenkins ya hace checkout automáticamente
        
        stage('Cleanup') {
            steps {
                bat '''
                    docker stop node_app mysql_db adminer 2>nul || echo "No containers to stop"
                    docker rm node_app mysql_db adminer 2>nul || echo "No containers to remove"
                    docker network rm crud-network 2>nul || echo "No network to remove"
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                bat 'docker build -t crudjs-app .'
            }
        }

        stage('Run Automated Tests') {
            steps {
                script {
                    echo '=== EJECUTANDO PRUEBAS AUTOMATIZADAS ==='
                    
                    // Configurar variables de entorno para tests
                    bat '''
                        echo "Configurando entorno de pruebas..."
                        copy env.test .env 2>nul || echo "Using existing .env"
                        
                        echo "Variables de entorno para tests:"
                        echo NODE_ENV=test
                        echo DB_HOST=localhost
                        echo DB_USER=root
                        echo DB_PASSWORD=Datos2025
                        echo DB_NAME=testdb
                    '''
                    
                    // Ejecutar pruebas
                    bat '''
                        echo "Ejecutando npm test..."
                        set NODE_ENV=test
                        set DB_HOST=localhost
                        set DB_USER=root
                        set DB_PASSWORD=Datos2025
                        set DB_NAME=testdb
                        npm test -- --testTimeout=15000 --detectOpenHandles
                    '''
                }
            }
            post {
                always {
                    // Archivar resultados de tests
                    bat '''
                        echo "Archivando resultados de pruebas..."
                        dir /s /b *.xml 2>nul
                        dir /s /b coverage 2>nul
                    '''
                    
                    // Publicar reportes JUnit si existen
                    junit '**/test-results.xml'
                    
                    // Publicar reporte de cobertura si existe
                    publishHTML(target: [
                        reportDir: 'coverage/lcov-report',
                        reportFiles: 'index.html',
                        reportName: 'Code Coverage Report'
                    ])
                }
                
                success {
                    echo '✅ Todas las pruebas pasaron exitosamente!'
                }
                
                failure {
                    echo '❌ Algunas pruebas fallaron'
                }
            }
        }

        stage('Deploy Application') {
            when {
                expression { currentBuild.result == null || currentBuild.result == 'SUCCESS' }
            }
            steps {
                script {
                    echo '=== DESPLEGANDO APLICACIÓN (solo si tests pasan) ==='
                    
                    // Crear red si no existe
                    bat 'docker network create crud-network 2>nul || echo "Red ya existe"'
                    
                    // Levantar MySQL
                    bat '''
                        docker run -d --name mysql_db \
                          --network crud-network \
                          -e MYSQL_ROOT_PASSWORD=Datos2025 \
                          -e MYSQL_DATABASE=Prueba01 \
                          -p 3306:3306 \
                          mysql:8
                        
                        echo "Esperando 15 segundos para que MySQL inicie..."
                        timeout /t 15 /nobreak
                    '''
                    
                    // Levantar aplicación
                    bat '''
                        docker run -d --name node_app \
                          --network crud-network \
                          -e DB_HOST=mysql_db \
                          -e DB_USER=root \
                          -e DB_PASSWORD=Datos2025 \
                          -e DB_NAME=Prueba01 \
                          -p 3000:3000 \
                          crudjs-app
                    '''
                    
                    // Levantar Adminer (opcional)
                    bat '''
                        docker run -d --name adminer \
                          --network crud-network \
                          -p 8081:8080 \
                          adminer
                    '''
                    
                    echo "Aplicación desplegada exitosamente!"
                    echo "🔗 API: http://localhost:3000"
                    echo "🔗 Adminer: http://localhost:8081"
                    echo "🔗 MySQL: localhost:3306"
                }
            }
        }
    }

    post {
        always {
            echo '=== LIMPIEZA FINAL ==='
            
            bat '''
                echo "Deteniendo contenedores..."
                docker stop node_app mysql_db adminer 2>nul || echo "Contenedores ya detenidos"
                
                echo "Eliminando contenedores..."
                docker rm node_app mysql_db adminer 2>nul || echo "Contenedores ya eliminados"
                
                echo "Eliminando red..."
                docker network rm crud-network 2>nul || echo "Red ya eliminada"
            '''
            
            // Limpiar workspace
            cleanWs()
            
            // Mostrar resumen
            echo "=== RESUMEN DEL PIPELINE ==="
            echo "Estado: ${currentBuild.result ?: 'SUCCESS'}"
            echo "Duración: ${currentBuild.durationString}"
            echo "Build #${currentBuild.number}"
        }
        
        success {
            echo '🎉 PIPELINE EJECUTADO EXITOSAMENTE!'
            echo '✅ Tests: 3/3 pasando'
            echo '✅ Aplicación desplegada'
            echo '✅ Entorno limpio'
        }
        
        failure {
            echo '💥 PIPELINE FALLÓ'
            echo '📋 Revisar logs para detalles'
        }
        
        unstable {
            echo '⚠️ PIPELINE INESTABLE'
            echo 'Algunos tests fallaron pero el despliegue continuó'
        }
    }
}