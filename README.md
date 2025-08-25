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

## Build de l'application pour la production via GitHub Actions


