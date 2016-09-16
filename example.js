var webdriverio = require('webdriverio');
var options = {
  desiredCapabilities: {
    browserName: 'chrome'
  },
  sync: true,
  //
  // Level of logging verbosity: silent | verbose | command | data | result | error
  logLevel: 'verbose',
  //
  // Enables colors for log output.
  coloredLogs: true,
  port: 4444
};

var client = webdriverio.remote(options);
client
  .init()
  .url('https://duckduckgo.com/')
  .setValue('#search_form_input_homepage', 'WebdriverIO')
  .click('#search_button_homepage')
  .getTitle().then(function(title) {
    console.log('Title is: ' + title);
    // outputs:
    // "Title is: WebdriverIO (Software) at DuckDuckGo"
  })
  .end();
