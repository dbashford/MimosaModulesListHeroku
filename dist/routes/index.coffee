fs = require 'fs'
path = require 'path'

redis = require '../lib/redis'

index = (config) ->
  options =
    reload:    config.liveReload.enabled
    optimize:  config.isOptimize ? false
    cachebust: if process.env.NODE_ENV isnt "production" then "?b=#{(new Date()).getTime()}" else ''
  (req, res) -> res.render "index", options

modules = (req, res) ->
  redis.get "registry", (err, data) ->
    res.json JSON.parse(data)

module.exports =
  index: index
  modules: modules