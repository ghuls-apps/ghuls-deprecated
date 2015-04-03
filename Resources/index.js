var menu = Ti.UI.createMenu(),
    fileMenu = Ti.UI.createMenuItem('File'),
    exit = fileMenu.addItem('Exit', exit()
);

function exit() {
    if (confirm('Are you sure that you want to exit?') {
        Ti.App.exit();
    }
}

function handleUsername() {
    if (form.username.value === "") {
        alert("Please provide a username");
    } else {
        var input = document.form.username.value;
        input.replace(/\\uB200/g, '');
        
        var jsonObject = {
            //"loginUsername":loginUsernameValue,
            //"loginPassword":loginPasswordValue,
            "analyzeUsername":input
        };
        
        writeToFile(form.username.value, JSON.stringify(jsonObject, null, 4);
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
