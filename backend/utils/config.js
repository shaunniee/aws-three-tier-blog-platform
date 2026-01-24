const AWS = require('aws-sdk');
const ssm = new AWS.SSM({ region: process.env.AWS_REGION });

async function getParameter(name, decrypt = false) {
  const result = await ssm.getParameter({ Name: name, WithDecryption: decrypt }).promise();
  return result.Parameter.Value;
}

async function loadConfig() {
  return {
    dbHost: await getParameter('/blogapp/database/endpoint'),
    dbPort: parseInt(await getParameter('/blogapp/database/port')),
    dbName: await getParameter('/blogapp/database/name'),
    dbUser: await getParameter('/blogapp/database/username'),
    dbSecretArn: await getParameter('/blogapp/db/secret_arn'), // Terraform output stored in SSM
    s3Bucket: await getParameter('/blogapp/s3/media/bucket/name'),
    cognitoUserPoolId: await getParameter('/blogapp/cognito/user_pool_id'),
    cognitoClientId: await getParameter('/blogapp/cognito/app_client_id')
  };
}

module.exports = { loadConfig };