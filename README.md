# OnErr Callback Wrapper Library

OnErr callback wrapper library contains a few convenience functions to reduce the number of checks needed to propagate errors up the callback chain.  The library simplifies code in coffeescript due to implied function calls, but can work in javascript too.

## Functions

### onErr

Calls the 'next' function if error, otherwise continues with normal callback

```coffeescript
# will call 'next' if error, the other callback is ignored
myFunction onErr next, (err, status) ->
  # will get here if there is no error
  ...
```

### onErrCall

Calls the 'next' function if error, otherwise continues with normal callback.  The 'next' function is "baked in" with a closure. This verion is useful for http request hanlders.

```coffeescript
httpReqHandler = (req, res, next) ->
  onErrNext = onErrCall next
  ...
  # will call 'next' if error
  myFunction onErrNext (err, status) ->
    ...

    # will call 'next' if error
    myFunction2 onErrNext (err, status) ->
    ...

```

### onCallbackApply

Ignores the arguments given to the inner function and uses the passed in arguments for the callback (if no error)

```coffeescript

# 'value' will be passed to callback and anything returned by myFunction will be dropped
# unless an error is returned by myFunction
value = "this will be passed to callback"
myFunction onCallbackApply value, callback

```

### onCallbackDo

Ignores arguments given to the inner function and uses the no arguments for the callback (if no error)

```coffeescript

# nothing will be passed to callback and anything returned by myFunction will be dropped
# unless an error is returned by myFunction
myFunction onCallbackDo callback

# can be useful at end of async lib calls
async.parallel [
  myFunction
], onCallbackDo callback

```

### nullCallback

A callback that does nothing but logs an error if it exists

```coffeescript

# sending email in background
sendMail email, nullCallback

```

### setGlobal

Sets all above functions to the global scope

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)