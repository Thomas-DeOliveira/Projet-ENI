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

Le dockerfile du frontend a été modifié pour la production en ajoutant des paramètres pour build en mode production. Et le serveur de développement `ng serve` a été remplacé par un serveur Nginx sur le port 80.
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

## Déploiement de du cluster AKS avec Terraform

Afin d'organiser le déploiement de l'infrastructure, j'ai organiser les ressources dans des modules.

Les fichiers de déploiement pour d'AKS sont dans le dossier AKSn le fichier main.tf est le suivant : 
```hcl
resource "azurerm_kubernetes_cluster" "k8s" {
  location            = var.location
  resource_group_name = var.resource_group_name
  name                = var.cluster_name
  dns_prefix          = var.dns_prefix

  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_B2S"
    node_count = 2
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"  # Utilisation d'Azure CNI
    network_policy = "calico"
    service_cidr   = "10.0.0.0/16"
    dns_service_ip = "10.0.0.10"
  }

  tags = var.tags
}
```
Les variables sont définies dans le fichier variables.tf :
```hcl
variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "cluster_name" {
  description = "Nom du cluster AKS"
  type        = string
  default     = "aks-projet-eni"
}

variable "dns_prefix" {
  description = "Préfixe DNS pour le cluster AKS"
  type        = string
  default     = "aks-projet-eni"
}

variable "subnet_id" {
  description = "ID du sous-réseau pour AKS"
  type        = string
}

variable "tags" {
  description = "Tags à appliquer aux ressources"
  type        = map(string)
  default     = {}
}
```
Afin d'isoler le cluster AKS, j'ai créé un réseau virtuel et un sous-réseau. Les fichiers de déploiement sont dans le module `network`:
```hcl
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}
```
## Mapping des secrets Azure Key Vault avec Kubernetes

```shell
az aks enable-addons --addons azure-keyvault-secrets-provider --resource-group rg-TDeOliveira2024_cours-projet --name aks-projet-eni
```

## Déploiement de la stack Grafana Prometheus et Alertmanager avec Helm

Ajouter les déôts Helm :


A la fin du déploiement, afin de récupérer le mot de passe admin de Grafana, exécuter la commande suivante :

```shell
kubectl --namespace monitoring get secrets monitoring-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```
```mermaid
graph LR
%% Direction
%% LR = gauche -> droite
%% TB = haut -> bas
%% On reste en LR pour compacité
%% ----------------------------------------------------------------
subgraph User[Utilisateurs]
U1[👤 Navigateur Web]
end

subgraph Azure[Azure]
subgraph RG[Resource Group]
subgraph AKS[AKS - Azure Kubernetes Service]
subgraph Ingress[Ingress NGINX]
IGW[🌐 Ingress Controller]
end

        subgraph NSApp[Namespace: app]
          FE[Deployment: frontend\nNginx -> Angular]
          BE[Deployment: backend\nNode.js + Express + Sequelize]
          SVC_FE[Service: frontend (ClusterIP)]
          SVC_BE[Service: backend (ClusterIP)]
          IGW -->|HTTP/HTTPS| SVC_FE
          IGW -->|/api| SVC_BE
          SVC_FE --> FE
          SVC_BE --> BE
        end

        subgraph NSCSI[Namespace: csi/kv]
          SPClass[SecretProviderClass]
          VolMount[Volume CSI (Key Vault)]
        end

        BE -. monte .-> VolMount
        VolMount -. fournit .-> BE
      end

      subgraph DB[AAD + Réseau + Base de Données]
        MySQL[Azure Database for MySQL\n(Flexible Server)]
        VNet[VNet/Subnet]
      end

      subgraph MON[Monitoring]
        PROM[Prometheus]
        GRAF[Grafana]
      end

      KV[(Azure Key Vault)]
    end
end

%% Flux utilisateur
U1 -->|HTTPS| IGW

%% Connexions backend
BE -->|TCP 3306| MySQL
BE -. Secrets (DB pwd) .-> KV

%% CSI
KV -->|Secrets| SPClass

%% Monitoring
FE -. metrics/logs .-> PROM
BE -. metrics/logs .-> PROM
PROM --> GRAF

%% Liaisons réseau
AKS --- VNet
MySQL --- VNet
```
