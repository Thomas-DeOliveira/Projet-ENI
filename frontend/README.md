# 📝 Projet ToDoList – Frontend Angular

Ce dépôt contient le frontend de l’application **ToDoList**, une application web de gestion de tâches conçue avec Angular. Il permet à un utilisateur de créer, modifier, supprimer et filtrer des tâches selon leur statut.

---

## 🧱 Stack technique

- **Framework** : [Angular 15](https://angular.io/)
- **Langage** : TypeScript
- **Design system** : Angular Material
- **Gestion des formulaires** : Reactive Forms
- **Tests unitaires** : Jasmine + Karma
- **Client HTTP** : HttpClient Angular

---

## 🚀 Lancement du projet

### ✅ Prérequis

- Node.js (version recommandée : >= 16)
- Angular CLI (version 15 installée globalement)

```bash
npm install -g @angular/cli@15
```

### 📦 Installation des dépendances

```bash
npm install
```

### ▶️ Démarrage du serveur de développement

```bash
ng serve
```

L'application sera accessible à l'adresse : [http://localhost:4200](http://localhost:4200)

---

## 🧪 Tests unitaires

```bash
ng test
```

Cela lance les tests unitaires avec **Karma** et **Jasmine**. Les tests sont définis dans les fichiers `*.spec.ts` à côté de chaque composant, service ou module testé.

ℹ️ **Aucun test end-to-end (e2e)** n’est présent dans ce projet.

---

## 📁 Arborescence du projet

```
src/
├── app/
│   ├── components/
│   │   ├── task-form/         # Composant de formulaire de tâche (création/modification)
│   │   │   └── task-form.component.*
│   │   ├── task-list/         # Composant d'affichage des tâches avec filtres
│   │   │   └── task-list.component.*
│   ├── services/
│   │   └── task.service.ts    # Service de communication avec l'API backend
│   ├── models/
│   │   └── task.model.ts      # Interface représentant une tâche
│   ├── app.component.*        # Composant racine et layout général
│   ├── app-routing.module.ts  # Configuration des routes Angular
│   └── app.module.ts          # Module principal de l'application
├── assets/                    # Fichiers statiques
└── index.html                 # Page HTML principale
```

---

## 🧩 Modules et fonctionnalités

### 📌 `task-list.component`
- Affiche la liste des tâches récupérées depuis le backend.
- Permet un filtrage par statut (`À faire`, `En cours`, `Terminée`).
- Propose des boutons d'action pour modifier ou supprimer chaque tâche.
- Composant réactif, rafraîchi automatiquement après suppression.

### ✍️ `task-form.component`
- Gère le formulaire d’ajout ou de modification de tâche.
- Détermine automatiquement le mode (`création` ou `édition`) selon la route (`/ajouter` ou `/modifier/:id`).
- Envoie les données au backend via le `TaskService`.

### 🔁 `task.service.ts`
- Contient les appels HTTP au backend :
  - `getAllTasks()`
  - `getTask(id)`
  - `addTask(task)`
  - `updateTask(task)`
  - `deleteTask(id)`
- Utilise `HttpClient` et renvoie des observables typés.

### 🧭 `app-routing.module.ts`
- Déclare les routes suivantes :
  - `/` → composant `TaskListComponent`
  - `/ajouter` → composant `TaskFormComponent`
  - `/modifier/:id` → composant `TaskFormComponent` en mode édition

### 🧱 `task.model.ts`
- Interface `Task` définissant les propriétés :
  - `id?: number`
  - `nom: string`
  - `description: string`
  - `statut: string`

---

## 📚 Bonnes pratiques

- La logique métier est centralisée dans le `TaskService`.
- L’UI est construite avec Angular Material pour un rendu cohérent et accessible.
- Les composants sont découplés et respectent le principe SRP (Single Responsibility Principle).
- Les routes sont définies de manière claire et intuitive.
- Le code est tapé fortement grâce à TypeScript et aux interfaces.

---

## 📎 Ressources utiles

- [Documentation Angular](https://angular.io/docs)
- [Angular CLI cheatsheet](https://angular.io/cli)
- [Angular Material](https://material.angular.io/components/categories)
