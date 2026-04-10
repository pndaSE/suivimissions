# Suivi des missions

[![Version](https://img.shields.io/badge/version-1.0.0-1d4c34)](https://github.com/KISUNGU/suivi-missions/releases/tag/v1.0.0)
[![Windows](https://img.shields.io/badge/platform-Windows-0f6cbd)](https://github.com/KISUNGU/suivi-missions/releases)
[![Electron](https://img.shields.io/badge/Electron-37.2.0-47848f)](https://www.electronjs.org/)
[![Release](https://img.shields.io/badge/download-releases-d3a52c)](https://github.com/KISUNGU/suivi-missions/releases)

Application desktop Electron pour le suivi des missions du PNDA-SE.

## Apercu

Le projet fournit une application Windows autonome avec :

- un formulaire de saisie des missions ;
- un tableau de bord administrateur ;
- un espace RNSE pour créer les utilisateurs, attribuer les rôles et gérer les accès ;
- l'export de donnees et de rapports Excel ;
- une generation d'executable portable via Electron Builder.

## Telechargement

- Page des releases : https://github.com/KISUNGU/suivi-missions/releases
- Version `v1.0.0` : https://github.com/KISUNGU/suivi-missions/releases/tag/v1.0.0

Quand un executable est publie dans une release, il peut etre telecharge directement depuis cette page.

## Prerequis

- Node.js 24 ou plus recent
- npm

## Installation

```powershell
npm install
```

## Lancement en developpement

```powershell
npm start
```

## Utilisation

Au lancement, l'application ouvre le formulaire principal de saisie.

Le menu de l'application permet ensuite de :

- revenir au formulaire de saisie ;
- ouvrir le tableau de bord administrateur ;
- recharger la fenetre ;
- ouvrir les outils developpeur ;
- exporter les donnees vers Excel.

## Scripts disponibles

- `npm start` : lance l'application Electron.
- `npm run pack` : produit un package non compresse dans `dist/`.
- `npm run dist` : genere l'executable Windows portable.

## Generation de l'executable

```powershell
npm run dist
```

Le build genere un executable Windows portable dans le dossier `dist/` avec un nom de la forme `PNDA-Missions-1.0.0.exe`.

## Structure principale

- `main.js` : processus principal Electron, menus et export Excel.
- `preload.js` : pont securise entre Electron et l'interface.
- `index.html` : interface de saisie.
- `admin.html` : tableau de bord administrateur.
- `superadmin.html` : espace RNSE pour la gestion des utilisateurs, rôles et référentiels.
- `pnda_reference.json` : referentiel de donnees.

## Depot GitHub

Le depot distant associe est :

https://github.com/KISUNGU/suivi-missions.git

## Licence

Projet `UNLICENSED`.