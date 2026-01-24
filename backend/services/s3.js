const AWS = require('aws-sdk');
let s3;

function initS3(config) {
  s3 = new AWS.S3({ region: process.env.AWS_REGION });
}

async function uploadFile(bucket, key, buffer, mimetype) {
  const params = { Bucket: bucket, Key: key, Body: buffer, ContentType: mimetype };
  const result = await s3.upload(params).promise();
  return result.Location;
}

module.exports = { initS3, uploadFile };