# stock_flutter

Application **Flutter SaaS** de gestion de stock simplifiée — examen ESISA *Partiel Programmation Mobile Vibe Coding* (M. Lahmer).

## Stack technique

| Couche | Technologie |
|--------|-------------|
| Architecture | **DDDA** — `domain` / `application` / `infrastructure` / `presentation` |
| Navigation | **GoRouter** (guards auth + écran setup Firebase) |
| État | **flutter_riverpod** |
| HTTP | **dio** (`lib/infrastructure/network/dio_client.dart`) |
| Backend | **Firebase Auth** (email/mot de passe), **Cloud Firestore** |
| Alertes | **flutter_local_notifications** (stock sous seuil) |
| Multi-tenant | `tenants/{tenantId}/products\|categories\|mouvements` — `tenantId` = UID utilisateur |

## Structure du projet

```
lib/
  domain/          # Entités + interfaces repositories
  application/     # Services métier, providers Riverpod
  infrastructure/  # Firebase, Firestore, dio, notifications
  presentation/    # Écrans UI
  core/            # Router, erreurs, tenant
```

## Prérequis

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable)
- Compte [Firebase](https://console.firebase.google.com/)
- Compte [GitHub](https://github.com/)
- Optionnel : [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)

### Vérifier Flutter

```powershell
flutter doctor
```

Si Flutter est absent, voir **GUIDE_FR.md** section *Installation Flutter*.

## Démarrage rapide

```powershell
cd C:\Users\ayaes\Projects\stock_flutter
.\scripts\setup_projet.ps1
```

Puis configurer Firebase (`flutterfire configure`) — détail dans **GUIDE_FR.md**.

```powershell
flutter pub get
flutter run
```

Sans Firebase configuré, l'app affiche l'écran **Configuration Firebase** (compilation possible, pas de crash).

## Fonctionnalités

- Ajout produit par catégorie (création catégorie si absente)
- Réapprovisionnement (entrée stock) et vente (sortie)
- Dashboard : stock total, ventes par plage de dates, top ventes, ventes par catégorie
- Notifications locales si quantité ≤ seuil de réapprovisionnement

## Sécurité Firestore

Exemple de règles : [`firestore.rules`](firestore.rules) — à déployer dans la console Firebase.

## Rapport examen (temps / tokens)

Remplir [`RAPPORT.md`](RAPPORT.md) à chaque session de vibe coding.

## Guide dépôt Git & examen

**→ [GUIDE_FR.md](GUIDE_FR.md)** (GitHub, collaborateur M-Lahmer, Firebase, commits, push)

## Collaborateur GitHub

Inviter **M-Lahmer** : *Settings → Collaborators* sur le dépôt `stock_flutter`.

## Licence / usage

Projet pédagogique ESISA — usage examen.
