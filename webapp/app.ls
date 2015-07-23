#!/usr/bin/env lsc

const SERVER_PORT = 9000

require! path
require! express
app = express!

app.use '/', express.static path.resolve "#{__dirname}/public"
app.use '/ls', express.static path.resolve "#{__dirname}/../src"

server = app.listen SERVER_PORT, ->
    addr = server.address!
    console.log "Listing at #{addr.address}:#{addr.port}"
