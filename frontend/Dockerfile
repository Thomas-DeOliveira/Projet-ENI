FROM node:18.13.0 as build

WORKDIR /app

COPY package*.json ./

ENV NODE_OPTIONS=--max-old-space-size=2048

RUN npm install

RUN npm install -g @angular/cli

COPY . .

RUN npm run build --prod

FROM nginx:alpine

COPY --from=build /app/dist/ /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
