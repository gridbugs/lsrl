#!/usr/bin/env lsc

const SERVER_PORT = 9000

require! path
require! express
app = express!

app.use '/ls', express.static path.resolve "#{__dirname}/../src"


app.get '/', (req, res) -> res.send "Hello, World!"
server = app.listen SERVER_PORT, ->
    addr = server.address!
    console.log "Listing at #{addr.address}:#{addr.port}"
