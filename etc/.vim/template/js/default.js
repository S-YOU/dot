const util = require('util');
util.inspect.defaultOptions.colors = false;
util.inspect.defaultOptions.depth = null;
util.inspect.defaultOptions.maxArrayLength = null;
util.inspect.defaultOptions.showHidden = false;

async function main() {
}

if (typeof require != 'undefined' && require.main == module) {
  main();
}
