var fs = require('fs');
var nw = require('nw');

function handleUsername() {
    if (form.username.value == "") {
        alert("You gotta provide input homie");
    } else {
        var input = document.form.username.value
        
        //var jsonText = '{ "inputInfo": [' + 
            //'{"loginUsername":"' + loginUsernamevalue + '"},' +
            //'{"loginPassword":"' + loginPasswordvalue + '"},' +
            //'"dataUsername":"' + input + '"} ] }';
        //var jsonObject = JSON.parse(jsonText);
        var jsonObject = {
            //"loginUsername":loginUsernameValue,
            //"loginPassword":loginPasswordValue,
            "analyzeUsername":input
        }
        $.ajax({
            type: "POST",
            dataType: "json",
            url: "json_handle.php",
            data: jsonObject,
            success: function() {
                alert('Yahooo!');
            error: function(e) {
                alert('Error occurred: ' + e);
            }
        });
        
        buffer = new Buffer(input);
        fs.open(path, 'w', function(err, fd) {
            if (err) {
                throw err;
            } else {
                fs.write(fd, buffer, 0, buffer.length, null, function(err) {
                    if (err) {
                        throw err;
                    } else {
                        fs.close(fd, function() {
                            alert('File written');
                        })
                    }
                });
            }
        });
    }
}
