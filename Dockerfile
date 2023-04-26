FROM node:16.20.0-alpine3.16 AS build-env

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY src ./src
COPY angular.json tsconfig.app.json tsconfig.json ./
RUN npm run build

FROM nginx:1.13.9-alpine

COPY --from=build-env /app/dist/binary-offline/ /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
