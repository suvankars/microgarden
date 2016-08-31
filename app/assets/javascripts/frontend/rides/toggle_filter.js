$(document).ready(function(){

  var button = document.getElementById('advanced_filter_button');

  if (button != null ){
    button.onclick = function() {
        var div = document.getElementById('advance_filter');
        if (div.style.display !== 'none') {
            div.style.display = 'none';
        }
        else {
            div.style.display = 'block';
        }
    };
  }  
});  