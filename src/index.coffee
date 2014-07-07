fs = require 'fs'
path = require 'path'
_ = require 'lodash'
util = require 'util'

start = (opts, callback) ->
  [opts, callback] = if _.isFunction(opts) then [{}, opts] else [opts, callback]
  replHistory = opts.historyFile ? "./.repl-history"
  repl = require("repl").start(opts.prompt ? ">> ")
  maxCb = opts.maxCb ? 10
  verbose = opts.verbose ? true
  inspectOpts =
    depth: opts.depth ? 2
    colors: true

  saveHistory = (callback) ->
    fs.writeFile replHistory, (repl.rli.history.reverse().join('\n') + '\n'), callback

  loadHistory = (callback) ->
    fs.exists replHistory, (exists) ->
      return callback(null) unless exists
      fs.readFile replHistory, encoding: 'utf8', (err, data) ->
        return callback(err) if err

        try
          lines = data.split '\n'
          for line in lines
            unless _.isEmpty(line)
              repl.rli.line = line
              repl.rli._addHistory()
              repl.rli.line = ''
              repl.lines.push line
          return callback(null)
        catch ex
          return callback(ex)

  repl.on 'exit', () ->
    saveHistory (err) ->
      console.error "error writing console history: #{err}" if err
      process.kill process.pid, 'SIGINT'

  process.on 'uncaughtException', (err) ->
    console.error "uncaughtException: #{err}" if err
    saveHistory (err) ->
      console.error "error writing console history: #{err}" if err
      process.kill process.pid, 'SIGINT'

  ctx = repl.context

  ctx.lo = require 'lodash'

  # borrowed from compound.js (https://github.com/1602/compound)
  ctx.cb = ->
    l = arguments.length

    message = "Callback called with #{l} argument"
    message += "s" unless l == 1
    message += ":\n" if l > 0

    i = 0
    while i < maxCb
      if i < arguments.length
        ctx["_" + i] = arguments[i]
        message += "_#{i} = "
        message += (if verbose then util.inspect(arguments[i], inspectOpts) else "#{arguments[i]}")
        message += "\n"
      else
        delete ctx["_" + i] if ctx.hasOwnProperty("_" + i)
      i += 1
    console.log message

  repl.defineCommand 'quit',
    help: 'Exit the repl',
    action: () -> repl.rli.close()

  repl.defineCommand 'clearHist',
    help: 'repl history cleared',
    action: () ->
      repl.lines = []
      repl.rli.history = repl.rli.history[0..0]
      repl.rli.historyIndex = -1
      console.log 'console history cleared'

  # load history
  loadHistory (err) ->
    callback(err, ctx)

  return repl

module.exports = {
  start: start
}
