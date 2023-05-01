// index.js

// Obtenemos la api key del parameter store
const AWS = require("aws-sdk");
const ssm = new AWS.SSM();
const https = require('https');

exports.handler = async function(event, context, callback) {
  const apiKey = await ssm.getParameter({
    Name: '/someapi/apikey',
    WithDecryption: true,
  }).promise();

  // Efectuamos la llamada y escribimos la respuesta en el log

  const options = {
    host: process.env.HOST,
    port: 443,
    path: process.env.ENDPOINT,
    method: 'POST',
    headers: {
      'X-api-key': apiKey.Parameter.Value
    }
  };

  return new Promise((resolve, reject) => {
    const req = https.request(options, (res) => {
      let dataString = '';

      console.log('Done!');

      res.on('data', chunk => {
        dataString += chunk;
      });

      res.on('end', () => {
        console.log(dataString);
        resolve(res.statusCode);
      });
    }).on("error", (e) => {
      reject(new Error(e));
    });

    req.end();
  });
};
