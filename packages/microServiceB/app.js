const express = require('express')
const app = express()
const port = process.env.NODE_PORT ? process.env.NODE_PORT : 8080
const version = process.env.VERSION ? process.env.VERSION : '1.0.0'


response = {
    "message": "Hello Guys from MicroServiceB",
    "status": "success",
    "version": version
 }

app.get('/', (req, res) => {
  res.send(response)
})


app.listen(port, () => {
  console.log(`MicroServieA Listening on port ${port}`)
})