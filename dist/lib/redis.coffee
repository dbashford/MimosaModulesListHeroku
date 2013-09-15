console.log "INSIDE REDIS"

if process.env.REDISTOGO_URL
  console.log "REDIS TO GO!"

  rtg   = require("url").parse(process.env.REDISTOGO_URL)
  redis = require("redis").createClient(rtg.port, rtg.hostname)
  console.log "GOING TO AUTH:", rtg.auth.split(":")[1]
  redis.auth(rtg.auth.split(":")[1])
else
  console.log "NO REDIS TO GO!"

  redis = require("redis").createClient()

redis.on "error", (err) ->
  console.log("Error " + err);

module.exports = redis