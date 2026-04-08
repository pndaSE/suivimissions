# Suivi des missions

Application desktop Electron pour le suivi des missions du PNDA-SE.

## Apercu

Le projet fournit une application Windows autonome avec :

- un formulaire de saisie des missions ;
- un tableau de bord administrateur ;
- l'export de donnees et de rapports Excel ;
- une generation d'executable portable via Electron Builder.

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
- `pnda_reference.json` : referentiel de donnees.

## Publication Git

Le depot distant GitHub associe est :

`https://github.com/KISUNGU/suivi-missions.git`

## Licence

Projet `UNLICENSED`.