////////////////////////////////////////////////////////////////////////////////
//   Node.jsのREPLを便利にするスクリプト
//
//   https://stackoverflow.com/questions/6769250/start-up-script-for-node-js-repl
////////////////////////////////////////////////////////////////////////////////

const repl = require('repl');

// https://nodejs.org/api/repl.html#repl_repl_start_options
let r = repl.start({ breakEvalOnSigint: true });

const util = require('util');
util.inspect.defaultOptions.colors = true;
util.inspect.defaultOptions.depth = null;
util.inspect.defaultOptions.maxArrayLength = null;
util.inspect.defaultOptions.showHidden = false;
