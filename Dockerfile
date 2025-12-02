FROM node:22

WORKDIR /app

# Copiamos package.json y package-lock.json
COPY package*.json ./

# Forzamos npm a usar mirror y prefer-offline
RUN npm config set registry https://registry.npmmirror.com/ \
    && npm ci --prefer-offline --no-audit --progress=false

# Copiamos el resto del código
COPY . .

# Puerto y comando
EXPOSE 3000
CMD ["npm", "start"]
