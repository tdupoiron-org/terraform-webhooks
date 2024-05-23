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
    console.error(error)
    response = {
      statusCode: 500,
      body: JSON.stringify("An error occurred: " + error.message),
    }
  })

  req.write(data)
  req.end()

  return response
}