const http = require('http');

exports.handler = async (event) => {
  let response = {
    statusCode: 200,
    body: JSON.stringify("Hello from Lambda and Github!"),
  }
  
  console.log(response);
  
  const data = JSON.stringify(event);

  const options = {
    hostname: 'elastic.dupoiron.com',
    port: 9200,
    path: '/github/_doc',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Content-Length': data.length,
      'Authorization': 'Basic ' + Buffer.from('username:password').toString('base64')
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