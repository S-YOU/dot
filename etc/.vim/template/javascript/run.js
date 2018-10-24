var app = require('./app.js');

var event = {
};

var context = {
  succeed: function(result) {
    console.log("Succeed");
    console.log(result);
  },
  fail: function(err) {
    console.log("Fail");
    console.log(err);
  }
};

app.handler(event, context);
