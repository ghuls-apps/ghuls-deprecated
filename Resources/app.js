var menu = Ti.UI.createMenu(),
    fileMenu = Ti.UI.createMenuItem('File'),
    exit = fileMenu.addItem('Exit', exit()
);

function exit() {
    if (confirm('Are you sure that you want to exit?') {
        Ti.App.exit();
    }
}

function handleUsername(username) {
    if (username.value === "") {
        window.alert("Please provide a username");
    } else {
        var input = document.username.value;
        input.replace(/\\uB200/g, '');

        var jsonObject = {
            //"loginUsername":loginUsernameValue,
            //"loginPassword":loginPasswordValue,
            "analyzeUsername":input
        };

        writeToFile(username.value, JSON.stringify(jsonObject, null, 4);
        Ti.App.stderr("username.value: " + username.value);
        Ti.App.stderr("username: " + username);
        Ti.App.stderr("document.username.value: " + document.username.value);
    }
}

function writeToFile(username, json) {
    var outputFileName = 'tmp/' + username + '.json';
    var outputFile = Ti.Filesystem.getFileStream(
      Ti.Filesystem.getApplicationDataDirectory(), outputFileName
    );

    outputFile.open(Ti.Filesystem.MODE_WRITE);
    outputFile.write(json);
    outputFile.close();
}
