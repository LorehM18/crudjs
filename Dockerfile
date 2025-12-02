# Usa Node 22
FROM node:22

# Crea el directorio de la app
WORKDIR /app

# Copia package.json y package-lock.json
COPY package*.json ./

# Instala dependencias
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm ci --prefer-offline --no-audit --progress=false

# Copia el resto de la app
COPY . .

# Copia el script de entrada
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Ejecuta el script al iniciar el contenedor
ENTRYPOINT ["docker-entrypoint.sh"]
