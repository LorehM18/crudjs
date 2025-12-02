# Usa una versión más estable de Node.js
FROM node:18-alpine

WORKDIR /app

# Copia primero los archivos de dependencias
COPY package*.json ./

# Instalación simple, sin mirror problemático
RUN npm config set registry https://registry.npmjs.org/ \
    && npm ci --no-audit --progress=false

# Copia el resto del código
COPY . .

# Exponer puerto
EXPOSE 3000

# Comando de inicio
CMD ["npm", "start"]