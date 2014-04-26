var page = require('webpage').create(),
    system = require('system'),
    address = system.args[1],
    output = "ganglion" + address.replace(/[^a-z0-9]/gi, '_') + ".pdf";
page.viewportSize = { width: 1024, height: 600 };
page.open(address, function (status) {
    if (status !== 'success') {
        console.log('Unable to load the address!');
        phantom.exit();
    } else {
        window.setTimeout(function () {
            page.render(output);
            phantom.exit();
        }, 200);
    }
});
