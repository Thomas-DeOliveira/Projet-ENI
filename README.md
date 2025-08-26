# Projet-ENI

## Démarrage de l'application en local sur docker

### Frontend

Création du Dockerfile :
```Dockerfile
FROM node:24-alpine

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN npm install -g @angular/cli

RUN npm install

CMD ["ng", "serve", "--host", "0.0.0.0"]
```

Build de l'image Docker :
```bash
docker build -t projet-eni-frontend .
```

### Backend

Création du Dockerfile :
```Dockerfile
FROM node:24-alpine

WORKDIR /usr/src/app

COPY . .

RUN npm install

EXPOSE 3000

ENTRYPOINT ["npm", "run", "start"]
```

Build de l'image Docker :
```bash
docker build -t projet-eni-backend .
```

### Run de l'application avec docker-compose et déploiement de la BDD

Le déploiement du frontend et du backend se fait avec docker-compose. Le fichier `.env` est utilisé pour la configuration des variables du backend.
La BDD est initialisée avec le script SQL `scriptSQL.sql` qui se trouve dans le dossier `backend`.
```yaml
version: '3'
services:
    database:
        image: mariadb
        environment:
            MYSQL_DATABASE: todolist_db
            MARIADB_ALLOW_EMPTY_ROOT_PASSWORD: "yes"
        volumes:
            - db_data:/var/lib/mysql
            - /home/thomas/projet-eni/backend/scriptSQL.sql:/docker-entrypoint-initdb.d/scriptSQL.sql \
        ports:
            - "3306:3306"


    frontend:
        image: frontend-projet-eni
        ports:
            - "4200:4200"

    backend:
        image: backend-projet-eni
        ports:
            - "3000:3000"

volumes:
    db_data:
```

Fichier .env :
```.env
DB_HOST=database
DB_USER=root
DB_PASSWORD=
DB_NAME=todolist_db
DB_DIALECT=mysql
PORT=3000
```

### Lancement de l'application
```bash
docker-compose up -d
```

## Build de l'application pour la production via GitHub Actions et tests unitaire

### Workflow GitHub Actions

Les secrets `DOCKER_USERNAME` et `DOCKER_PASSWORD` doivent être configurés dans les paramètres du dépôt GitHub.
Pour le frontend, le workflow est déclenché à chaque push sur la branche `main`. Il réalise les tests unitaires, build l'image Docker et la pousse sur Docker Hub.
```yaml
name: Build Frontend Docker Image

on:
  push:
    branches: [ "main" ]
    paths:
      - 'frontend/**'

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '24'

      - name: Install Angular CLI
        run: npm install -g @angular/cli

      - name: Run tests
        working-directory: ./frontend
        continue-on-error: true
        run: |
          npm install
          npx ng test --watch=false --browsers=ChromeHeadless

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: ./frontend
          file: ./frontend/Dockerfile
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/frontend-projet-eni:latest
```
Pour le backend, le workflow est déclenché à chaque push sur la branche `main`. Il réalise les tests unitaires, build l'image Docker et la pousse sur Docker Hub.
```yaml
name: Build Backend Docker Image

on:
  push:
    branches: [ "main" ]
    paths:
      - 'backend/**'

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '24'

      - name: Run tests
        working-directory: ./backend
        continue-on-error: true
        run: |
          npm install
          npm run test -- --watch=false --browsers=ChromeHeadless

      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Set up QEMU
        uses: docker/setup-qemu-action@v3

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Build and push
        uses: docker/build-push-action@v6
        with:
          context: ./backend
          file: ./backend/Dockerfile
          push: true
          tags: ${{ secrets.DOCKER_USERNAME }}/backend-projet-eni:latest
```
Les tests unitaires sont configurés pour continuer même en cas d'échec (`continue-on-error: true`) afin de ne pas bloquer le processus de build et de déploiement. Car l'application doit être déployée même si certains tests échouent.

Le dockerfile du frontend a été modifié pour la production en ajoutant des paramètres pour build en mode production. Et le serveur de développement `ng serve` a été remplacé par un serveur Nginx.
```Dockerfile
FROM node:24 as build

WORKDIR /app

COPY package*.json ./

RUN npm install

RUN npm install -g @angular/cli

COPY . .

RUN npm run build --prod

FROM nginx:alpine

COPY --from=build /app/dist/frontend/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Les images sont maintenant déployées sur Docker Hub, il est possible de déployer la stack docker-compose en production en utilisant les images depuis Docker Hub.

```yaml
services:
    database:
        image: mariadb
        environment:
            MYSQL_DATABASE: todolist_db
            MARIADB_ALLOW_EMPTY_ROOT_PASSWORD: "yes"
        volumes:
            - db_data:/var/lib/mysql
            - /home/thomas/projet-eni/backend/scriptSQL.sql:/docker-entrypoint-initdb.d/scriptSQL.sql \
        ports:
            - "3306:3306"

    frontend:
        image: thomasdeo/frontend-projet-eni:latest
        ports:
            - "80:80"

    backend:
        image: thomasdeo/backend-projet-eni:latest
        ports:
            - "3000:3000"

volumes:
    db_data:
```
