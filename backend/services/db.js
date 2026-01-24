const { Pool } = require('pg');
const { getDbPassword } = require('../utils/secrets');

let pool;

async function initDb(config) {
  const dbPassword = await getDbPassword(config.dbSecretArn);

  pool = new Pool({
    host: config.dbHost,
    port: config.dbPort,
    database: config.dbName,
    user: config.dbUser,
    password: dbPassword,
    ssl: { rejectUnauthorized: false } // adjust if SSL required
  });

  await pool.query('SELECT 1'); // test connection
  console.log('Connected to RDS using Secrets Manager ARN');
}

function getDb() {
  if (!pool) throw new Error('Database not initialized');
  return pool;
}

module.exports = { initDb, getDb };