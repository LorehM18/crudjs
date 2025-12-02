FROM node:22

WORKDIR /app

COPY package*.json ./

RUN npm install --fetch-timeout=120000 --fetch-retries=10

COPY . .

EXPOSE 3000

CMD ["node", "src/index.js"]
