#!/bin/sh
set -e

# Nombre del contenedor de MySQL que usas en Docker
DB_HOST=mysql_db
DB_PORT=3306

echo "Esperando a que MySQL esté listo en $DB_HOST:$DB_PORT..."

# Espera hasta que MySQL esté disponible
while ! nc -z $DB_HOST $DB_PORT; do
  echo "MySQL no está listo, esperando 2 segundos..."
  sleep 2
done

echo "MySQL listo, iniciando tests de la aplicación..."

# Ejecuta los tests de Node
npm test

echo "Tests finalizados correctamente."

# Mantener el contenedor vivo para que puedas revisar logs si quieres (opcional)
tail -f /dev/null
