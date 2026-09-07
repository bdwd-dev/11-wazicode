# WaziCode

Plateforme Développeur Africaine — Sandbox vérifiée

**Organisation :** WaziCode

## Structure

```
11-wazicode/
├── backend/          # Express.js API (Port 3011)
│   ├── server.js
│   ├── package.json
│   └── db.json
├── web/              # React frontend (HTML + Babel standalone)
│   └── index.html
└── mobile/           # Flutter app
    └── lib/main.dart
```

## Démarrage

```bash
# Backend
cd 11-wazicode/backend
npm install
npm start

# Web — Ouvrir 11-wazicode/web/index.html dans un navigateur
# ou servir avec: npx serve 11-wazicode/web

# Mobile
cd 11-wazicode/mobile
flutter pub get
flutter run
```

## API

| Endpoint | Description |
|----------|-------------|
| GET /api/health | Health check |
| GET /api/stats | Statistiques |
