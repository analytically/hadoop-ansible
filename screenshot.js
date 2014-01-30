var args = require('system').args;

if (args.length === 3) {
    var url = args[1];
    var filename = args[2];

    var page = require('webpage').create();
    page.viewportSize = { width: 1280, height: 800 };
    page.open(url, function () {
        page.onConsoleMessage = function (msg) {
            console.log(msg);
        };

        window.setTimeout(function () {
            page.render(filename);
            phantom.exit();
        }, 200);
    });
}
else {
    console.log('usage: phantomjs screenshot.js url filename');
}