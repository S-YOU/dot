const util = require('util');
util.inspect.defaultOptions.colors = false;
util.inspect.defaultOptions.depth = null;
util.inspect.defaultOptions.maxArrayLength = null;
util.inspect.defaultOptions.showHidden = false;

#CURSOR#async function main() {
}

if (typeof require != 'undefined' && require.main == module) {
  main();
}
