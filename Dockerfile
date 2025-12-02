FROM node:22

WORKDIR /app

COPY package*.json ./

RUN npm install --fetch-timeout=60000 --fetch-retries=5

COPY . .

EXPOSE 3000

CMD ["node", "src/index.js"]
