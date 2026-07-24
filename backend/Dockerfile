FROM node:20
#"Start from an image that already has Node.js 20 installed."
WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

EXPOSE 5000

CMD ["npm","start"]