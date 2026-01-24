const AWS = require('aws-sdk');
const secretsManager = new AWS.SecretsManager({ region: process.env.AWS_REGION });

async function getDbPassword(secretArn) {
  const data = await secretsManager.getSecretValue({ SecretId: secretArn }).promise();
  if ('SecretString' in data) {
    const secret = JSON.parse(data.SecretString);
    return secret.password; // RDS master password
  }
  throw new Error('Secret not found or binary secret not supported');
}

module.exports = { getDbPassword };