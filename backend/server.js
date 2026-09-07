const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(cors());
app.use(express.json());

const DB_PATH = path.join(__dirname, 'db.json');

function loadDB() {
  try { return JSON.parse(fs.readFileSync(DB_PATH, 'utf8')); }
  catch { return { users: [], api_keys: [], transactions: [], sdks: [], sandboxes: [] }; }
}

function saveDB(data) {
  fs.writeFileSync(DB_PATH, JSON.stringify(data, null, 2));
}

// Health check
app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', service: 'wazicode', version: '1.0.0' });
});

// Stats
app.get('/api/stats', (req, res) => {
  const db = loadDB();
  res.json({
    users: db.users.length,
    api_keys: db.api_keys.length,
    transactions: db.transactions.length,
    sdks: db.sdks.length,
    sandboxes: db.sandboxes.length
  });
});

// Users
app.get('/api/users', (req, res) => {
  const db = loadDB();
  res.json(db.users);
});

app.post('/api/users', (req, res) => {
  const db = loadDB();
  const user = { id: Date.now(), ...req.body, created_at: new Date().toISOString() };
  db.users.push(user);
  saveDB(db);
  res.json(user);
});

// API Keys
app.get('/api/api-keys', (req, res) => {
  const db = loadDB();
  res.json(db.api_keys);
});

app.post('/api/api-keys', (req, res) => {
  const db = loadDB();
  const apiKey = {
    id: Date.now(),
    user_id: req.body.user_id,
    key: 'wz_' + Math.random().toString(36).substr(2, 32),
    name: req.body.name || 'Default Key',
    status: 'active',
    created_at: new Date().toISOString()
  };
  db.api_keys.push(apiKey);
  saveDB(db);
  res.json(apiKey);
});

// SDKs
app.get('/api/sdks', (req, res) => {
  const db = loadDB();
  res.json(db.sdks);
});

// Sandbox transactions (simulated Mobile Money, SMS, USSD)
app.get('/api/sandboxes', (req, res) => {
  const db = loadDB();
  res.json(db.sandboxes);
});

app.post('/api/sandbox/mobile-money', (req, res) => {
  const db = loadDB();
  const { phone, amount, provider } = req.body;
  const tx = {
    id: Date.now(),
    type: 'mobile_money',
    phone,
    amount,
    provider: provider || 'MTN',
    status: 'success',
    reference: 'MM' + Date.now(),
    timestamp: new Date().toISOString()
  };
  db.transactions.push(tx);
  db.sandboxes.push(tx);
  saveDB(db);
  res.json({ success: true, transaction: tx, message: `Paiement Mobile Money simulé: ${amount} XAF vers ${phone}` });
});

app.post('/api/sandbox/sms', (req, res) => {
  const db = loadDB();
  const { phone, message } = req.body;
  const tx = {
    id: Date.now(),
    type: 'sms',
    phone,
    message: message || 'Message test WaziCode',
    status: 'delivered',
    timestamp: new Date().toISOString()
  };
  db.transactions.push(tx);
  db.sandboxes.push(tx);
  saveDB(db);
  res.json({ success: true, transaction: tx, message: `SMS simulé envoyé à ${phone}` });
});

app.post('/api/sandbox/ussd', (req, res) => {
  const db = loadDB();
  const { code, phone } = req.body;
  const tx = {
    id: Date.now(),
    type: 'ussd',
    code: code || '*123#',
    phone,
    status: 'session_active',
    response: 'Bienvenue WaziCode\n1. Solde\n2. Transfert\n3. Aide',
    timestamp: new Date().toISOString()
  };
  db.transactions.push(tx);
  db.sandboxes.push(tx);
  saveDB(db);
  res.json({ success: true, transaction: tx });
});

// Transactions
app.get('/api/transactions', (req, res) => {
  const db = loadDB();
  res.json(db.transactions.slice(-50).reverse());
});

const PORT = process.env.PORT || 3011;
app.listen(PORT, () => {
  console.log(`╔═══════════════════════════════════════════════╗`);
  console.log(`║  💻 WAZICODE - Plateforme Développeur       ║`);
  console.log(`║  Port: ${PORT}                                  ║`);
  console.log(`║  API: http://localhost:${PORT}/api            ║`);
  console.log(`╚═══════════════════════════════════════════════╝`);
});
