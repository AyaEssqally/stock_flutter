# Guide complet — stock_flutter (ESISA · M. Lahmer)

Ce document décrit **étape par étape** la création du dépôt GitHub, l'invitation du correcteur, la configuration Firebase, l'exécution de l'application et le **workflow d'examen** (commits, push, rapport temps/tokens).

---

## Table des matières

1. [Prérequis](#1-prérequis)
2. [Installation de Flutter (si absent)](#2-installation-de-flutter-si-absent)
3. [Finaliser le projet local](#3-finaliser-le-projet-local)
4. [Créer le compte et le dépôt GitHub](#4-créer-le-compte-et-le-dépôt-github)
5. [Lier le dépôt local à GitHub](#5-lier-le-dépôt-local-à-github)
6. [Inviter le collaborateur M-Lahmer](#6-inviter-le-collaborateur-m-lahmer)
7. [Configurer Firebase](#7-configurer-firebase)
8. [FlutterFire (`flutterfire configure`)](#8-flutterfire-flutterfire-configure)
9. [Règles Firestore multi-tenant](#9-règles-firestore-multi-tenant)
10. [Lancer l'application](#10-lancer-lapplication)
11. [Workflow examen : commit → push → rapport](#11-workflow-examen--commit--push--rapport)
12. [Vibe coding avec Cursor / Gemini](#12-vibe-coding-avec-cursor--gemini)
13. [Dépannage](#13-dépannage)

---

## 1. Prérequis

- Windows 10/11 avec PowerShell
- Connexion Internet
- Compte **GitHub** (gratuit)
- Compte **Google** pour Firebase
- **Git** installé : `git --version`
- **Flutter** installé (voir section 2)

Chemin du projet fourni par le correcteur :

```
C:\Users\ayaes\Projects\stock_flutter
```

---

## 2. Installation de Flutter (si absent)

1. Télécharger le SDK : https://docs.flutter.dev/get-started/install/windows  
2. Extraire (ex. `C:\src\flutter`) et ajouter au **PATH** : `C:\src\flutter\bin`
3. Installer **Android Studio** (SDK Android + émulateur) : https://developer.android.com/studio  
4. Accepter les licences :

```powershell
flutter doctor --android-licenses
```

5. Vérifier :

```powershell
flutter doctor
```

Corrigez chaque ligne marquée avec `!` ou `X` avant l'examen.

---

## 3. Finaliser le projet local

Ouvrir PowerShell :

```powershell
cd C:\Users\ayaes\Projects\stock_flutter
```

### 3.1 Initialiser Git (si pas déjà fait)

```powershell
git init
git branch -M main
```

### 3.2 Générer les dossiers plateforme (si `android/` absent)

```powershell
flutter create . --org com.esisa.stock
```

### 3.3 Installer les dépendances

```powershell
flutter pub get
```

### 3.4 Créer les commits logiques (script fourni)

```powershell
.\scripts\git_commits_examen.ps1
```

Ou exécuter manuellement des commits après chaque fonctionnalité (voir section 11).

Vérifier l'historique :

```powershell
git log --oneline
```

---

## 4. Créer le compte et le dépôt GitHub

1. Aller sur https://github.com/signup et créer un compte (si besoin).
2. Se connecter → bouton **+** → **New repository**.
3. Paramètres :
   - **Repository name** : `stock_flutter` (obligatoire pour le sujet)
   - **Description** : `ESISA - Gestion de stock Flutter SaaS`
   - Visibilité : **Public** ou **Private** (selon consigne du professeur)
   - **Ne pas** cocher "Add a README" (le projet local en a déjà un)
4. Cliquer **Create repository**.
5. Noter l'URL HTTPS, par exemple :

```
https://github.com/VOTRE_USERNAME/stock_flutter.git
```

---

## 5. Lier le dépôt local à GitHub

Dans le dossier du projet :

```powershell
cd C:\Users\ayaes\Projects\stock_flutter
git remote add origin https://github.com/VOTRE_USERNAME/stock_flutter.git
```

Vérifier :

```powershell
git remote -v
```

Premier envoi (après au moins un commit) :

```powershell
git push -u origin main
```

GitHub peut demander une authentification :
- **Personal Access Token (classic)** avec scope `repo`, ou
- **GitHub CLI** : `gh auth login` puis `git push`

> Ne commitez jamais `google-services.json`, `.env`, ni un vrai `firebase_options.dart` avec clés secrètes sur un dépôt public. Le projet utilise un placeholder jusqu'à `flutterfire configure`.

---

## 6. Inviter le collaborateur M-Lahmer

1. Ouvrir le dépôt `stock_flutter` sur GitHub.
2. **Settings** (onglet du dépôt).
3. Menu gauche → **Collaborators** (ou **Collaborators and teams**).
4. **Add people**.
5. Saisir le nom d'utilisateur GitHub du professeur : **`M-Lahmer`**.
6. Choisir le rôle **Write** (ou **Maintain** selon besoin).
7. Envoyer l'invitation — M. Lahmer doit **accepter** l'email ou la notification GitHub.

Capture d'écran recommandée pour le rapport d'examen.

---

## 7. Configurer Firebase

1. Console : https://console.firebase.google.com/
2. **Ajouter un projet** → nom ex. `stock-flutter-esisa`.
3. Désactiver Google Analytics si vous voulez aller plus vite (optionnel).
4. Dans le projet :

### Authentication

- Menu **Authentication** → **Sign-in method**
- Activer **Email/Password**
- Enregistrer

### Cloud Firestore

- Menu **Firestore Database** → **Create database**
- Mode **test** pour développement (à remplacer par règles strictes avant production)
- Région proche (ex. `europe-west1`)

### Applications

- Icône engrenage → **Paramètres du projet**
- Section **Vos applications** → ajouter :
  - **Android** : package `com.esisa.stock.stock_flutter` (vérifier dans `android/app/build.gradle` après `flutter create`)
  - **Web** / **Windows** si vous ciblez ces plateformes

---

## 8. FlutterFire (`flutterfire configure`)

### Installer la CLI

```powershell
dart pub global activate flutterfire_cli
```

Ajouter au PATH si besoin (message affiché par la commande), ex. :

```
%LOCALAPPDATA%\Pub\Cache\bin
```

### Configurer le projet

```powershell
cd C:\Users\ayaes\Projects\stock_flutter
flutterfire configure
```

- Sélectionner le projet Firebase créé.
- Cocher les plateformes (Android, Web, etc.).
- La commande régénère **`lib/firebase_options.dart`** et peut ajouter `google-services.json` (Android).

> **Important** : `google-services.json` est dans `.gitignore`. Pour un dépôt d'examen, le correcteur configure Firebase de son côté ou vous fournissez les fichiers hors Git.

Redémarrer l'app :

```powershell
flutter run
```

---

## 9. Règles Firestore multi-tenant

Le modèle de données isole chaque client :

```
tenants/{tenantId}/products/{id}
tenants/{tenantId}/categories/{id}
tenants/{tenantId}/mouvements/{id}
```

`tenantId` = **UID Firebase Auth** de l'utilisateur connecté.

### Déployer les règles

1. Copier le contenu de [`firestore.rules`](firestore.rules) du projet.
2. Console Firebase → **Firestore** → **Règles**.
3. Coller → **Publier**.

### Index composite (si erreur de requête dashboard)

Si Firestore demande un index pour les requêtes par date sur `mouvements`, cliquer le lien dans le message d'erreur de la console ou créer manuellement :

- Collection : `tenants/{tenantId}/mouvements`
- Champs : `date` (Ascending/Descending selon requête)

---

## 10. Lancer l'application

```powershell
cd C:\Users\ayaes\Projects\stock_flutter
flutter pub get
flutter devices
flutter run
```

### Parcours utilisateur

1. Si Firebase non configuré → écran **Configuration Firebase**.
2. Sinon → **Inscription** (`/register`) puis **Connexion**.
3. Navigation : **Produits**, **Catégories**, **Mouvements**, **Dashboard**.
4. Sur un produit : menu → **Réappro** ou **Vente**.
5. Stock bas → notification locale (émulateur/appareil physique).

---

## 11. Workflow examen : commit → push → rapport

### Messages de commit (exemples)

| Commit | Message suggéré |
|--------|-----------------|
| Init | `chore: initialisation projet Flutter et dépendances` |
| Domaine | `feat(domain): entités et repositories` |
| Infra | `feat(infrastructure): Firebase multi-tenant et notifications` |
| UI | `feat(presentation): écrans et navigation GoRouter` |
| Docs | `docs: guide examen et règles Firestore` |

Style : impératif, en français ou anglais clair.

### Après chaque modification significative

```powershell
git add .
git status
git commit -m "feat(products): ajout dialogue création produit"
git push origin main
```

### Rapport temps et tokens

Ouvrir [`RAPPORT.md`](RAPPORT.md) et noter pour chaque session :

- Date / heure début–fin
- Durée totale
- Outil (Cursor Agent, Gemini, etc.)
- Estimation tokens ou crédits (si visible dans Cursor)
- Résumé de ce qui a été fait

Cela fait partie de l'évaluation **vibe coding**.

---

## 12. Vibe coding avec Cursor / Gemini

- **Cursor** (Agent, Composer) accélère la génération de code DDDA, écrans et intégration Firebase.
- **Android Studio Gemini** ou l'assistant intégré aide pour Gradle, émulateur et widgets Flutter.
- Une **clé API Gemini** n'est **pas obligatoire** pour ce sujet : le backend est **Firebase**. Si vous ajoutez plus tard une fonctionnalité IA (suggestions de réappro, OCR factures), vous pourrez configurer une clé dans les paramètres de l'IDE — ne la commitez pas.

Bonnes pratiques examen :

- Demander des commits petits et explicites.
- Tester sur émulateur après chaque feature.
- Documenter les blocages dans `RAPPORT.md`.

---

## 13. Dépannage

| Problème | Solution |
|----------|----------|
| `flutter` introuvable | Réinstaller SDK, vérifier PATH, redémarrer le terminal |
| `Firebase not configured` | Lancer `flutterfire configure`, redémarrer l'app |
| `permission-denied` Firestore | Vérifier règles + utilisateur connecté + bon `tenantId` |
| `git push` refusé | Token GitHub, `gh auth login`, ou SSH |
| Notifications absentes | Tester sur appareil réel ; vérifier permissions Android 13+ |
| Build Android échoue | `flutter clean` puis `flutter pub get` |

---

## Checklist avant rendu

- [ ] Dépôt GitHub nommé `stock_flutter`
- [ ] Collaborateur **M-Lahmer** invité
- [ ] Plusieurs commits explicites + push
- [ ] Firebase Auth email + Firestore actifs
- [ ] `flutterfire configure` exécuté localement
- [ ] `RAPPORT.md` rempli (temps + tokens)
- [ ] App démo : produit, réappro, vente, dashboard

**Bon courage pour le partiel ESISA.**
