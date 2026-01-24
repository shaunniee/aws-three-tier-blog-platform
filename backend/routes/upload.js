const express = require('express');
const multer = require('multer');
const router = express.Router();
const { uploadFile } = require('../services/s3');
const { authenticateToken } = require('../middleware/auth');

const upload = multer({ storage: multer.memoryStorage() });

router.post('/', authenticateToken, upload.single('file'), async (req, res) => {
  const file = req.file;
  if (!file) return res.status(400).send('No file uploaded');

  const key = `uploads/${Date.now()}-${file.originalname}`;
  const url = await uploadFile(process.env.S3_BUCKET, key, file.buffer, file.mimetype);
  res.json({ url });
});

module.exports = router;