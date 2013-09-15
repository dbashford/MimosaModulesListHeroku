if process.env.REDISTOGO_URL
  rtg   = require("url").parse(process.env.REDISTOGO_URL)
  redis = require("redis").createClient(rtg.port, rtg.hostname)
else
  redis = require("redis").createClient()

module.exports = redis