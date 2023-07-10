
function read(file) {
    var request = new XMLHttpRequest();
    request.open("GET", file, false); // false为同步操作设置
    request.send(null);
    return request.responseText;
}

//鹰：不支持相对路径
function write(file, text) {
    var request = new XMLHttpRequest();
    request.open("PUT", file, false); // false为同步操作设置
    request.send(text);
    return request.status;
}



function saveText(filename, contentText) {
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.HEADERS_RECEIVED) {
            console.log(xhr.getAllResponseHeaders());
        } else if (xhr.readyState == XMLHttpRequest.DONE) {
            console.log(xhr.getAllResponseHeaders());
        }
    };
    xhr.open("PUT", filename);
    xhr.send(contentText.toString());
}
