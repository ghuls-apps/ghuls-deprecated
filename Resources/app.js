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
    if (username === "") {
        alert("Please provide a username");
    } else {
        var input = document.username;
        input.replace(/\\uB200/g, '');
        
        var jsonObject = {
            //"loginUsername":loginUsernameValue,
            //"loginPassword":loginPasswordValue,
            "analyzeUsername":input
        };
        
        writeToFile(username, JSON.stringify(jsonObject, null, 4);
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
