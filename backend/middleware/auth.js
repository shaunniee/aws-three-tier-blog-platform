const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

let client;
let cognitoIssuer;

function initAuth(userPoolId, region) {
  cognitoIssuer = `https://cognito-idp.${region}.amazonaws.com/${userPoolId}`;
  client = jwksClient({ jwksUri: `${cognitoIssuer}/.well-known/jwks.json` });
}

function getKey(header, callback) {
  client.getSigningKey(header.kid, (err, key) => {
    if (err) return callback(err);
    callback(null, key.getPublicKey());
  });
}

function authenticateToken(req, res, next) {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.sendStatus(401);

  jwt.verify(token, getKey, { issuer: cognitoIssuer }, (err, decoded) => {
    if (err) return res.sendStatus(403);
    req.user = decoded;
    next();
  });
}

module.exports = { initAuth, authenticateToken };