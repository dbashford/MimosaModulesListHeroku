fs = require 'fs'
path = require 'path'

registryPath = path.join __dirname, '..', 'registry.json'

index = (config) ->

  options =
    reload:    config.liveReload.enabled
    optimize:  config.isOptimize ? false
    cachebust: if process.env.NODE_ENV isnt "production" then "?b=#{(new Date()).getTime()}" else ''

  (req, res) -> res.render "index", options

modules = (req, res) ->
  registryString = fs.readFileSync registryPath, 'ascii'
  registryJSON = JSON.parse registryString
  res.json registryJSON

module.exports =
  index: index
  modules: modules