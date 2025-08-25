FROM node:20-alpine as build

WORKDIR /usr/src/app

COPY frontend/package*.json ./
RUN npm install

COPY . .
RUN npm run build --prod

FROM nginx:alpine

COPY --from=build /usr/src/app/dist/ /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
