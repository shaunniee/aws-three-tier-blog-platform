const express = require('express');
const cors = require('cors');
const { loadConfig } = require('./utils/config');
const { initDb } = require('./services/db');
const { initS3 } = require('./services/s3');
const { initAuth } = require('./middleware/auth');

const postsRoute = require('./routes/posts');
const uploadRoute = require('./routes/upload');

(async () => {
  const config = await loadConfig();
  process.env.S3_BUCKET = config.s3Bucket;

  // await initDb(config);            // RDS connection via Secrets Manager ARN
  initS3(config);                  // S3 client
  initAuth(config.cognitoUserPoolId, process.env.AWS_REGION); // Cognito auth

  const app = express();
  app.use(cors());
  app.use(express.json());

  app.use('/posts', postsRoute);
  app.use('/upload', uploadRoute);

  app.listen(3000, () => console.log('Backend running on port 3000'));
})();