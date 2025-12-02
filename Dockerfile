# Usamos la imagen base de Node 22
FROM node:22

# Creamos el directorio de trabajo
WORKDIR /app

# Copiamos solo package.json y package-lock.json para aprovechar cache
COPY package*.json ./

# Actualizamos npm y usamos un mirror para evitar timeouts
RUN npm install -g npm@11.6.4 \
    && npm config set registry https://registry.npmmirror.com/ \
    && npm ci --prefer-offline --no-audit --progress=false

# Copiamos el resto de la app
COPY . .

# Exponemos el puerto que usa tu app (ajústalo si es necesario)
EXPOSE 3000

# Comando por defecto para correr la app
CMD ["npm", "start"]
