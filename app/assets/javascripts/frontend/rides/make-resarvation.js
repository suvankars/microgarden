$(document).ready(function(){
  $('#create_reservations').on('click', function() {
    console.log("I am about to explode")
    debugger;
    var $spinner = $('.spinner');
    var elm = document.getElementById("ride_number_of_workstations");
    var no_of_ws = elm.options[elm.selectedIndex].value
    var startTime = $("#schedule-start").text();
    var endTime = $("#schedule-end").text();
    var address = $("#address").text().trim();
    var price = $("#ride-fare").text();
    var ride_id = document.getElementById("ride_id").innerText

    var valuesToSubmit = {id: ride_id,
                          startTime: startTime,
                          endTime: endTime,
                          address: address,
                          price: price,
                          no_of_ws: no_of_ws};
  
  console.log(valuesToSubmit);

    event.preventDefault();
    $.ajax({
      type: "POST",
      data: valuesToSubmit,
      url: '/frontend/reservations/create',
      beforeSend: show_spinner,
      complete: hide_spinner,
      success: show_resarvation_status(startTime, endTime, price),
      error: handle_error
    });

    
    function show_spinner() {
      $spinner.show();
    }

    function hide_spinner() {
      $spinner.hide();
    }

    function handle_error(xhr) {
      alert(xhr.responseText);
    }
  })

});


show_resarvation_status = function (startTime, endTime, price){
    $('#after-reservation').show();
    $("#reservation-details").hide();
    $("#revervaion-calendar").hide();
    //var msg = "<h3>A Slot has been booked for you<h3> </br> from " + startTime + " "  + endTime;
    //$("#reservation-details").replaceWith( msg );
    $('#ride-start-time').text(startTime);
    $('#ride-end-time').text(endTime);
    $('#ride-price').text(price);
    console.log("A Slot has been booked")
  }
