FROM node:14

WORKDIR /usr/src/app

COPY src ./src
COPY package.json package.json
COPY package-lock.json package-lock.json

RUN npm install

CMD npm start