FROM node:20
#"Start from an image that already has Node.js 20 installed."
# use alpine version of node image to reduce image size
WORKDIR /app

COPY package*.json ./
# it reads the package.json and package-lock.json files and copies them into the working directory of the image.


RUN npm ci
#installs dependecies not source code

COPY . .
# copy everyting

EXPOSE 5000

CMD ["npm","start"]
#only when the container is run, it will execute the command npm start to start the application.