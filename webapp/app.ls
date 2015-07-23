#!/usr/bin/env lsc

const SERVER_PORT = 9000

require! express
app = express!

app.get '/', (req, res) -> res.send "Hello, World!"
server = app.listen SERVER_PORT, ->
    addr = server.address!
    console.log "Listing at #{addr.address}:#{addr.port}"
