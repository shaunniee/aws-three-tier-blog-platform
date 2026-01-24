const express = require('express');
const router = express.Router();
const { getDb } = require('../services/db');
const { authenticateToken } = require('../middleware/auth');

// Public GET posts
router.get('/', async (req, res) => {
  const db = getDb();
  const result = await db.query('SELECT * FROM posts ORDER BY created_at DESC');
  res.json(result.rows);
});

// Authenticated POST
router.post('/', authenticateToken, async (req, res) => {
  const { title, content, image_url } = req.body;
  const user_id = req.user.sub; // Cognito user sub
  const db = getDb();

  const result = await db.query(
    'INSERT INTO posts (user_id, title, content, image_url) VALUES ($1, $2, $3, $4) RETURNING *',
    [user_id, title, content, image_url]
  );
  res.json(result.rows[0]);
});

module.exports = router;