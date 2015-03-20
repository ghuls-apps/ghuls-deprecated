var fs = require('fs');
var nw = require('nw');

function handleUsername() {
    if (form.username.value === "") {
        alert("You gotta provide input homie");
    } else {
        var input = document.form.username.value;
        input.replace(/\uB200/g, '');
        
        //var jsonText = '{ "inputInfo": [' + 
            //'{"loginUsername":"' + loginUsernamevalue + '"},' +
            //'{"loginPassword":"' + loginPasswordvalue + '"},' +
            //'"dataUsername":"' + input + '"} ] }';
        //var jsonObject = JSON.parse(jsonText);
        var jsonObject = {
            //"loginUsername":loginUsernameValue,
            //"loginPassword":loginPasswordValue,
            "analyzeUsername":input
        };
        
        var outputFile = 'tmp/data.json';
        
        fs.writeFile(outputFile, JSON.stringify(jsonObject, null, 4), function(err) {
            if(err) {
                console.log(err);
            } else {
                console.log("JSON saved to " + outputFile);
            }
        });
    }
}
