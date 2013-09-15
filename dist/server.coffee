express = require 'express'
engines = require 'consolidate'
routes  = require './routes'

redis = require './lib/redis'
registry = require './registry.json'
redis.set "registry", JSON.stringify registry, null, 2

exports.startServer = (config, callback) ->

  port = process.env.PORT or config.server.port

  app = express()
  server = app.listen port, ->
    console.log "Express server listening on port %d in %s mode", server.address().port, app.settings.env

  app.configure ->
    app.set 'port', port
    app.set 'views', config.server.views.path
    app.engine config.server.views.extension, engines[config.server.views.compileWith]
    app.set 'view engine', config.server.views.extension
    app.use express.favicon()
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.compress()
    app.use config.server.base, app.router
    app.use express.static(config.watch.compiledDir)

  app.configure 'development', ->
    app.use express.errorHandler()

  # disabling web app for now, eventually web app for modules
  # app.get '/', routes.index(config)
  app.get '/modules', routes.modules

  callback(server)

