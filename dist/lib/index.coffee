fs = require 'fs'
path = require 'path'

_ = require 'lodash'
npm = require 'npm'

redis = require './redis'

writeOutput = (mods) ->
  mods = _.sortBy mods, (mod) -> mod.name
  console.log "Writing #{mods.length} modules to registry."
  redis.set "registry", JSON.stringify(mods, null, 2)
  redis.end()

npmOpts =
  outfd: null
  exit: false
  loglevel:'silent'

npm.load npmOpts, ->
  npm.commands.search ['mimosa-'], true, (err, pkgs) ->
    if err
      logger.error "Problem accessing NPM: #{err}"
    else
      packageNames = Object.keys(pkgs)

      mods = []
      i = 0
      add = (mod) ->
        if mod
          mods.push mod
        if ++i is packageNames.length
          writeOutput(mods)

      packageNames.forEach (pkg) ->
        npm.commands.view [pkg], true, (err, packageInfo) ->

          if packageInfo
            for version, data of packageInfo
              add
                name:         data.name
                version:      version
                site:         data.homepage
                dependencies: data.dependencies
                desc:         data.description
                updated:      data.time[version].replace('T', ' ').replace(/\.\w+$/,'')
                pastVersions: data.versions
                keywords:     data.keywords
          else
            add null