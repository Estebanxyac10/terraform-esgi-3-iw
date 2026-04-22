const express = require('express');
const cors = require('cors');
const axios = require('axios');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
app.use(express.json());
app.use(cors());

const useDatabase = process.env.DATABASE_URL !== undefined;
const USER_SERVICE_URL = process.env.USER_SERVICE_URL || 'http://localhost:3001';

let pool;
if (useDatabase) {
  pool = new Pool({ connectionString: process.env.DATABASE_URL });
}

// --- Fallback in-memory ---
let memNotifications = [];
let nextId = 1;

// --- Initialisation de la table ---
async function initDb() {
  if (!useDatabase) return;
  await pool.query(`
    CREATE TABLE IF NOT EXISTS notifications (
      id SERIAL PRIMARY KEY,
      user_id INTEGER NOT NULL,
      message TEXT NOT NULL,
      sent_at TIMESTAMP DEFAULT NOW()
    )
  `);
  console.log('Table notifications créée');
}

// --- Routes ---

app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'notification-service' });
});

app.post('/notify', async (req, res) => {
  const { user_id, message } = req.body;
  if (!user_id || !message) {
    return res.status(400).json({ error: 'user_id et message requis' });
  }
  try {
    // Vérifier que l'utilisateur existe via le user-service
    await axios.get(`${USER_SERVICE_URL}/users/${user_id}`);

    if (useDatabase) {
      const { rows } = await pool.query(
        'INSERT INTO notifications (user_id, message) VALUES ($1, $2) RETURNING *',
        [user_id, message]
      );
      return res.status(201).json(rows[0]);
    }
    const notification = { id: nextId++, user_id, message, sent_at: new Date() };
    memNotifications.push(notification);
    res.status(201).json(notification);
  } catch (err) {
    if (err.response && err.response.status === 404) {
      return res.status(404).json({ error: 'Utilisateur introuvable' });
    }
    res.status(500).json({ error: err.message });
  }
});

app.get('/notifications', async (req, res) => {
  try {
    if (useDatabase) {
      const { rows } = await pool.query('SELECT * FROM notifications ORDER BY id');
      return res.json(rows);
    }
    res.json(memNotifications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.get('/notifications/:user_id', async (req, res) => {
  const user_id = parseInt(req.params.user_id);
  try {
    if (useDatabase) {
      const { rows } = await pool.query(
        'SELECT * FROM notifications WHERE user_id = $1 ORDER BY id',
        [user_id]
      );
      return res.json(rows);
    }
    res.json(memNotifications.filter(n => n.user_id === user_id));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

const PORT = process.env.PORT || 3004;
app.listen(PORT, async () => {
  await initDb();
  console.log(`notification-service démarré sur le port ${PORT}`);
});
