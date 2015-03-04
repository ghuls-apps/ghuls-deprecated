var fs = require('fs');

function handleUsername() {
    if (form.username.value == "") {
        alert("You gotta provide input homie");
    } else {
        var input = document.form.username.value
        var path = 'tmp/user.txt',
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
