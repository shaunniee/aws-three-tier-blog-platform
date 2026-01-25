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


// GET /posts/me - get posts created by logged-in user
router.get('/me', authenticateToken, async (req, res) => {
  const db = getDb();
  const userId = req.user.sub; // Cognito user id

  try {
    const result = await db.query(
      `
      SELECT *
      FROM posts
      WHERE created_by = $1
      ORDER BY created_at DESC
      `,
      [userId]
    );

    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to fetch user posts' });
  }
});

// Authenticated POST
router.post('/', authenticateToken, async (req, res) => {
  console.log("Creating post with data:", req.body);
  const { title, content, image_url } = req.body;
  let description=content;
  const user_id = req.user.sub; // Cognito user sub
  const db = getDb();

  const result = await db.query(
    'INSERT INTO posts (created_by, title, description, image_url) VALUES ($1, $2, $3, $4) RETURNING *',
    [user_id, title, content, image_url]
  );
  res.json(result.rows[0]);
});

// DELETE /posts/:id - delete a post by logged-in user
router.delete('/:id', authenticateToken, async (req, res) => {
  const postId = req.params.id;
  const userId = req.user.sub;
  const db = getDb();

  try {
    // Only delete post if it belongs to the user
    const result = await db.query(
      'DELETE FROM posts WHERE post_id = $1 AND created_by = $2 RETURNING *',
      [postId, userId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: 'Post not found or not yours' });
    }

    res.json({ message: 'Post deleted successfully' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Failed to delete post' });
  }
});


// PUT /posts/:id - update a post
router.put('/:id', authenticateToken, async (req, res) => {
  const postId = req.params.id;
  const userId = req.user.sub;
  const { title, description, image_url } = req.body;
  const db = getDb();

  if (!postId) return res.status(400).json({ message: "Post ID is required" });

  try {
    // Only update if the user owns the post
    const result = await db.query(
      `UPDATE posts 
       SET title = $1, description = $2, image_url = $3, created_at = NOW()
       WHERE post_id = $4 AND created_by = $5
       RETURNING *`,
      [title, description, image_url, postId, userId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Post not found or not yours" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: "Failed to update post" });
  }
});

module.exports = router;