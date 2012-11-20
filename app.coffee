express = require 'express'
app = express()
fs = require 'fs'
nowjs = require 'now'
everyone = nowjs.initialize app
data = require './data'

config = JSON.parse fs.readFileSync('config.json')

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.static __dirname + '/public'
  app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.get '/', (req, res) ->
  res.render 'index.html'

app.listen config.port
console.log "Express server listening on port #{config.port}"

everyone.now.load = (key, callback) ->
  data.load key, callback

everyone.now.save = (key, val, callback) ->
  data.save key, val, callback




