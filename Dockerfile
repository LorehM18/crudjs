# Usamos Node.js 22 LTS
FROM node:22

# Directorio de la app
WORKDIR /app

# Copiamos archivos de dependencias
COPY package*.json ./

# Instalamos dependencias de forma offline (usa package-lock.json)
RUN npm ci --prefer-offline --no-audit --progress=false

# Copiamos el resto del código
COPY . .

# Puerto de la app
EXPOSE 3000

# Comando para ejecutar la app
CMD ["npm", "start"]
