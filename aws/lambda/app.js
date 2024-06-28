const http = require('http');

exports.handler = async (event) => {
  let response = {
    statusCode: 200,
    body: JSON.stringify("Event received"),
  }
  
  const parsedBody = JSON.parse(event.body);

  const data = JSON.stringify({
    '@timestamp': new Date(event.requestContext.requestTimeEpoch).toISOString(),
    event: parsedBody
  });

  const options = {
    hostname: 'elastic.dupoiron.com',
    port: 9200,
    path: '/github/_doc',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': data.length,
    }
  }

  const req = http.request(options, res => {
    console.log(`statusCode: ${res.statusCode}`)

    res.on('data', d => {
      process.stdout.write(d)
    })
  })

  req.on('error', error => {
    // Sanitize the error message before logging
    const sanitizedErrorMessage = error.message.replace(/[\r\n]+/g, ' ');
    console.error(`An error occurred: ${sanitizedErrorMessage}`);
    
    // Ensure the response is properly constructed without directly including the error object
    response = {
      statusCode: 500,
      body: JSON.stringify(`An error occurred: ${sanitizedErrorMessage}`),
    };
  });

  req.write(data)
  req.end()

  return response
}