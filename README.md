# Quick Repl

An extension of the node repl that includes automatic history loading and saving, plus a callback logger and utility.  Useful for debugging an asynchronous node server or app.

On load, it will attempt to load the history file which can be retrieved through the arrow keys.  On exit, it will automatically save the history back to the file.

Other features include the 'cb' placeholder that you can use in place of a callback (very similar to the one provided in compound.js (https://github.com/1602/compound).  It will output the values returned to it and make them available in the repl.

lodash is also automatically available in the repl as 'lo'.

## Install

```shell
npm install --save-dev quick-repl
```

## Simple Example

```javascript
var quickRepl = require('quick-repl');

quickRepl.start(function(err, context) {
  // check err

  // add custom additions from your application to the context
  context.foo = function() {
    return 1;
  }
});

```

This brings up the repl.

```javascript

// repl history is loading from ./.repl-history

>> var bar = function(cb) { cb("hello", [1, 2, 3], {}); };
undefined
>> bar(cb)
Callback called with 3 arguments:
_0 = 'hello'
_1 = [ 1, 2, 3 ]
_2 = {}

undefined
>> lo.isArray(_1)
true
>> foo()
1
>> .exit

// repl history is saved to ./.repl-history

```

### Options

Quick repl takes the following options:

```javascript

// the options defaults
var opts = {
  historyFile: "./.repl-history", // name of history file to write to and read from
  prompt: ">> ",                  // prompt to use in the repl
  maxCb: 10,                      // maxmium number of arguments 'cb' will save in _$n properties
  verbose: true,                  // use util.inspect instead of toString for cb logging
  depth: 2                        // util.inspect depth option
};

quickRepl.start(opts, function(err, context) {
  //...
});

```

## License

[MIT License](http://en.wikipedia.org/wiki/MIT_License)