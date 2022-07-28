var idx = 0;
var divHeight = 0;
var msgText = '';
var maxFileSize = 0;

function initFiles(maxSize) {
  this.maxFileSize = maxSize;
  var span = document.createElement('span');
  span.id = "clearAll";
  document.getElementById('files').appendChild(span);
  var pSize = document.getElementsByTagName('span');
  for (var i = 0; i < pSize.length; i++)
    if(pSize.className == 'pSize')
      pSize[i].innerHTML = getFileSize(pSize[i].innerHTML);
  createInput();
}
function createInput(){
  var f = document.createElement("input");
  f.type = "file";
  f.multiple = true;
  f.name = "files";
  f.style.display = "none";
  f.onchange = function(){setFile(f)};
  document.getElementById('clearAll').appendChild(f);
  return f;
}
function setFile(dom){
  for(var i=0;i<dom.files.length;i++)
    addFile(dom.files[i]);
}
function chooseFile(){
  var f = createInput();
  f.click();
}
function addFile(file){
  idx++;
  var f = document.createElement("input");
  f.id = "file" + idx;
  f.type = "file";
  f.name = "files";
  f.style.display = "none";
  divHeight += 31;
  document.getElementById("files").setAttribute("style", "height:" + divHeight + "px");
  document.getElementById("files").setAttribute("style", "text-align:center");
  var tr = document.createElement("tr");
  tr.id = "span" + idx;
  tr.innerHTML = "<td style='max-width: 200px; overflow-x: hidden;' nowrap><i class='icon icon-file'></i>&nbsp;" + file.name + "<td style='text-align:right'>" + getFileSize(file.size) + "<td width='30'>&nbsp;</tr>";
  if(file.size <= maxFileSize) {
    document.getElementById("fileTable").appendChild(tr);
    document.getElementById("fileList").appendChild(f);
  } else {
    alert('BIG_SIZE: ' + file.name + "\nMAX_SIZE:" + getFileSize(maxFileSize) + "\nFILE_SIZE: " + getFileSize(file.size));
  }
}
function getFileSize(size){
  var str = '0';
  if(size < 1024)
    str = size + ' Bayt';
  if(size > 1024 && size < (1024*1024))
    str = (size/1024).toFixed(2) + ' KB';
  if(size > (1024*1024))
    str = (size/(1024*1024)).toFixed(2) + ' MB';
  return str;
}

function clearAll(){
  idx = 0;
  $('#fileTable').html('');
  $('#fileList').html('');
  divHeight = 0;
  $('#files').removeClass('remFile').css('height','22px').css('textAlign','center').css('backgroundColor', '#FEFEFE').css('padding','10px');  //.css('border','1px solid #ababab')
  //if(!isAdd)
  $('#clearAll').html($('#clearAll').html());
}
$(document).ready(function(){
  $('#files').on( 'drag dragstart dragend dragover dragenter dragleave drop', function( e ) {
    e.preventDefault();
    e.stopPropagation();
  });
  $('#files').on('drop', function( e ){
    var r = e.originalEvent.dataTransfer.files;
    for(var i=0;i<r.length;i++) {
      addFile(r[i]);
    }
  });
});