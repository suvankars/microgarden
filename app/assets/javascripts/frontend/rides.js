//For Schedule Calendar 
$('#calendar').fullCalendar();
var updateEvent;
var display;
var refetch_events_and_close_dialog;
var show_resarvation_status;

//Initialized full callender 
$(document).ready(function() {
  if(document.getElementById("ride-info")){
    var ride_id = $("#ride-info").data('ride').ride_id  
  }
  
  var dialog_form = $('<div id="dialog-form">Loading form...</div>').dialog({
    autoOpen: false,
    height: 350,
    width: 700,
    modal: true,
    buttons: {
        'Create event': function () {
            debugger;
            $(this).dialog('close');
        },
        Cancel: function () {
            $(this).dialog('close');
        }
    },

    close: function () {
    }
  });
  return $('#calendar').fullCalendar({
    editable: true,
    selectable: true,
    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    },
    defaultView: 'month',
    height: 400,

     
    slotMinutes: 30,
    eventSources: [
      {
        url: '/rides/' + ride_id + '/get_rides'
      }
    ],
    timeFormat: 'h:mm',
    dragOpacity: "0.5",

    eventDrop: function( event, delta, revertFunc, jsEvent, ui, view ){
      move(event, delta, revertFunc, jsEvent, ui, view);
    },
    eventResize: function(event, delta, revertFunc, jsEvent, ui, view ){
      resize(event, delta, revertFunc, jsEvent, ui, view);
    },
    eventClick: function(event, jsEvent, view){
      debugger;
      console.log("Event click happened....")
      var path  = window.location.pathname;
      var regexp = /rides\/\d+$/;
      var booking_page = path.match(regexp)
      if (booking_page){
        console.log("Going to Book the Slot")
        bookSlot(event);
      } else {
        console.log("Going to Update the Event")
        updateEventDetails(event);
      }

      
    },
    select: function( startDate, endDate, allDay, jsEvent, view ) {
      display({ 
        starttime: new Date(startDate.toDate()), 
        endtime:   endDate.toDate(), 
        allDay:    allDay
      })
    },
  });
});

refetch_events_and_close_dialog = function (){
      $('#calendar').fullCalendar('refetchEvents');
      $('.dialog:visible').dialog('destroy');
    }

display = function(options) {
  $('#event_form').remove('');
  fetch(options);
},

destroy = function(action_url){
  console.log(action_url)
  $.ajax({
    dataType: 'script',
    type: 'delete',
    url: action_url,
    success: refetch_events_and_close_dialog
  });
},

render= function(options){
      debugger;
      console.log(options['starttime']);
      console.log(options['endtime']);

      $('#event_form').trigger('reset');
      
      var startTime = options['starttime']
      var endTime = options['endtime'];
      var type = '#schedule_start_time';
      var time = startTime
      var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
      $year.val(time.getFullYear());
      $month.prop('selectedIndex', time.getUTCMonth());
      $day.prop('selectedIndex', time.getUTCDate() - 1);
      $hour.prop('selectedIndex', time.getUTCHours());
      $minute.prop('selectedIndex', time.getUTCMinutes());

      var type = '#schedule_end_time';
      var time = endTime;
      var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
      console.log($year.val(time.getFullYear()));
      $year.val(time.getFullYear());
      $month.prop('selectedIndex', time.getMonth());
      $day.prop('selectedIndex', time.getDate() - 1);
      $hour.prop('selectedIndex', time.getUTCHours());
      $minute.prop('selectedIndex', time.getUTCMinutes());

      $('#create_event_dialog').dialog({
        title: 'New Event',
        modal: true,
        width: 500,
        close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
      });
},

// make_it_work_setTime =  function(type, time) {
//   //$('#event_form').remove('')

//   var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
//   console.log($year.val(time.getFullYear()));
//   $year.val(time.getFullYear());
//   $month.attr('selectedIndex', time.getMonth());
//   $day.attr('selectedIndex', time.getDate() - 1);
//   $hour.attr('selectedIndex', time.getHours());
//   $minute.attr('selectedIndex', time.getMinutes());
// },

fetch = function(options){
  if(document.getElementById("ride-info")){
    var ride_id = $("#ride-info").data('ride').ride_id 

    $.ajax({
      type: 'get',
      dataType: 'script',
      async: true,
      url: "/rides/" + ride_id + "/schedules/new",
      success: function(){ render(options) }
    });
  }  
},


 move = function(the_event, delta, revertFunc, jsEvent, ui, view ){
  var ride_id = $("#ride-info").data('ride').ride_id 

    $.ajax({
        url : "/rides/" + ride_id + "/schedules/" + the_event.id +"/move" ,
        type : "PATCH",
        data:  'title=' + the_event.title + '&delta=' + delta,
        dataType: 'script',
        async: true,
        error: function(xhr){
          revertFunc();
          alert(JSON.parse(xhr.responseText)["message"])
        }
    }); 
},

resize = function(the_event, delta, revertFunc, jsEvent, ui, view ) {
  //Move and resize basically does the same job; add delta to start and end time
  // For move add delta to both start and end time
  // For resize add delta to only end time
  //For seperation of concern create two method and two action in controller to uodate data
  //There Might be a better way we can handle dis.

  var ride_id = $("#ride-info").data('ride').ride_id 

  $.ajax({
      url : "/rides/" + ride_id + "/schedules/" + the_event.id +"/resize" ,
      type : "PATCH",
      data:  'title=' + the_event.title + '&delta=' + delta,
      dataType: 'script',
      async: true,
      error: function(xhr){
        revertFunc();
        alert(JSON.parse(xhr.responseText)["message"])
      }
  }); 
 
};



renderUpdateForm = function(){

};


updateEventDetails = function(schedule){
  var ride_id = $("#ride-info").data('ride').ride_id 
  $.ajax({
        type: 'GET',
        dataType: 'script',
        async: true,
        url : "/rides/" + ride_id + "/schedules/" + schedule.id + "/edit",

        success: function(){ renderUpdateForm() }
  });
  
  $('#event_desc_dialog').dialog({
        title: "Update Schedules",
        modal: true,
        width: 500,
        close: function(event, ui){ $('#event_desc_dialog').html(''); $('#event_desc_dialog').dialog('destroy') }
  }); 
}  

$(document).ready(function(){
  $('#create_event_dialog, #event_desc_dialog').on('submit', "#event_form, #modify_form", function(event) {
    var $spinner = $('.spinner');
    event.preventDefault();
    $.ajax({
      type: "POST",
      data: $(this).serialize(),
      url: $(this).attr('action'),
      beforeSend: show_spinner,
      complete: hide_spinner,
      success: refetch_events_and_close_dialog,
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

  $('input.ride').on('change', function() {
    $('input.ride').not(this).prop('checked', false);  
  });

});


//To Show the map in the ride details page
// $(document).ready(function() {
//     var lat = $("#bike_latitude").val();
//     var long = $("#bike_longitude").val();
//     var ride_title = $("#ride_title").text();

//     handler = Gmaps.build('Google');
//     handler.buildMap({ 
//     internal: {id: 'ride_marker'},
//     provider: {
//       zoom:15,
//     }
//     }, function(){
//     var marker = handler.addMarker({
//       lat: lat,
//       lng: long,
//       infowindow: ride_title
//     });
    
//       handler.map.centerOn(marker);
//     });
    
//   });    



//IMAGE UPLOAD


// $.cloudinary.config({ cloud_name: 'dijs1yfba', api_key: '488196417269728'});

// $(document).ready(function() {
//   var uploaderElements = document.getElementsByTagName("upload_image");
 
//   for (var i=0; i < uploaderElements.length; i++){
//     var element = uploaderElements[i]
//     var uploadWidget = element.firstElementChild;
//     var imagePreview = element.lastElementChild;
//     debugger;
//     uploadImage(uploadWidget, imagePreview);
//   };
  
// });


// uploadImage = function(uploadWidget, imagePreview){
//   //debugger;
//   uploadWidget.addEventListener("click", function() {
//     cloudinary.openUploadWidget({ cloud_name: 'dijs1yfba', upload_preset: 'sample_a3cb73f3e13fc75f53e20e800352e1b509ee1f7b'}, 
//       function(error, result) { 
//         displayImage(error, result, imagePreview);
//       });

//   }, false);
// };

// displayImage = function(error, result, imagePreview){
//   var preview = imagePreview.children[1];
//   var image_type = preview.id;
//   //Need to check this html() stuff
//   //debugger;

  
 
//   imagePreview.firstElementChild.innerText="";
 
//   var arrayLength = result.length;
//   // var bsRow = document.createElement("div")
//   // bsRow.className = "row"
//   // preview.appendChild(bsRow);

//   for (var i = 0; i < arrayLength; i++) {
//     var imageMetadata = result[i];
//     var bsGrid = document.createElement("div")
    

//     //temporary fix for enlarge profile pic thumb
    
//     bsGrid = addStyleClass(bsGrid, image_type)
    

//     //public id => "preset_folder/vbq2nef9th8hyxvxnhai"
//     //after split and pop => vbq2nef9th8hyxvxnhai
//     //debugger;
//     var image_id = imageMetadata.public_id.split("/").pop();
//     bsGrid.id = image_id;
//     preview.appendChild(bsGrid);
//     //debugger;
//     //A quick fix for not showing pdf thumbnil 
//     var format = imageMetadata.format
//     if (format == "pdf"){
//       //Then down load a png thumb nil for quick response
//       format = "png"
//     }  

//     $.cloudinary.image(imageMetadata.public_id, {
//         format: format, width: 200, height: 200, crop: "fit"
//       }).appendTo(bsGrid);

//       var image_tag = $('<a/>').
//       addClass('delete_by_token').
//       attr({href: '#'}).
//       html('&times;');

//       image_tag.appendTo(bsGrid).click(function(e) {
//         e.preventDefault();
        

//         $.cloudinary.delete_by_token(imageMetadata.delete_token).done(function(){
//           //Remove the image div from the dom
//           $("#" + image_id).html('');
//           //REMOVE FROM PARK IMAGE AREA other wise it will only delete from cloudinary
//           //Not from our server
//           var data = { image_id: imageMetadata.public_id};
//           removedParkedImage(data);
//         }).fail(function() {
//             $('.status').text("Cannot delete image");
//           });
//     });
//   }
      
       
//   processResponse(result, image_type); 
      
// };

// addStyleClass = function(bsGrid, image_type){
//   if (image_type == "profile_pic"){
//       bsGrid.className = "col-xs-12 col-sm-12 col-md-12 col-lg-9"
//     }
//   else{
//       bsGrid.className = "col-xs-12 col-sm-12 col-md-12 col-lg-3"
//   }
//   return bsGrid;
// };

// processResponse =  function(result, image_type){
//     //Can we make it more generic so that in ride and rider
//     // both case we could use it
//     //debugger;
//     var form_type = $("[class^=simple_form]").attr('id');


//     //new_rider, new_owner, edit_rider_1, edit_owner_1

//     var resource_id = form_type.split('_').splice(-1)[0]; //ex.  1, 2, 3
//     var resource_type = form_type.split('_')[1]; //ex. "rider", "owner"
//     var form_type = form_type.split('_')[0];   //ex. "new" ,"edit"

//     var action_path = "/images/park_images";
//     var request_type = "post";
//     //var resource_type = "Rider";
//     // var re = /edit_rider_\d+/i;
//     // var edit_ride = form_type.match(re);

//     // var regx = /new_[a-z]+*/i;
//     // var new_form = form_type.match(regx);


//     if (form_type == "new"){
//       var json_data = { image_type: image_type, resource_type: resource_type, data_value: result }
//       saveResponse(action_path, request_type, json_data);
//     } else if ( form_type == "edit" ){
//       var json_data = { image_type: image_type, id: resource_id, resource_type: resource_type, data_value: result }
//       saveResponse(action_path, request_type, json_data);
//     }
    
// };

// saveResponse = function(action_path, request_type, json_data){
//   $.ajax({
//     url : action_path,
//     type : request_type,
//     data : json_data
//   });
// };


// removedParkedImage = function (data){
//   $.ajax({
//     url : "/images/removed_parked_image",
//     type : 'post',
//     data : data
//   });
// };

/*


$.cloudinary.config({ cloud_name: 'dijs1yfba', api_key: '488196417269728'});


  document.getElementById("upload_widget_opener").addEventListener("click", function() {

    cloudinary.openUploadWidget({ cloud_name: 'dijs1yfba', upload_preset: 'sample_a3cb73f3e13fc75f53e20e800352e1b509ee1f7b'}, 
      function(error, result) { console.log(error, result);
      var preview = $(".preview");
      $(".status").text("");
 
      var arrayLength = result.length;
      for (var i = 0; i < arrayLength; i++) {
        var imageMetadata = result[i];
        
        $.cloudinary.image(imageMetadata.public_id, {
            format: result.format, width: 100, height: 100, crop: "fit"
          }).appendTo(preview);

           $('<a/>').
          addClass('delete_by_token').
          attr({href: '#'}).
          html('&times;').
          appendTo(preview).click(function() {
            $.cloudinary.delete_by_token(imageMetadata.delete_token).done(function(){
             
              
            }).fail(function() {
                $('.status').text("Cannot delete image");
              });
        });
      }
      
       
      /Make a function  How bad one can code, I wonder of myself:) 
      var form_type = $("[class^=simple_form]").attr('id');
      /var action_path = '/images' + $("[class^=simple_form]").attr('action');
      var resource_id = form_type.split('_').splice(-1)[0];
      var action_path = "/images/park_images";
      var request_type = "post";
      var resource_type = "List";

      if (form_type == "new_ride"){
        request_type = "post";
        resource_type = "List"
      }

      var json_data = { resource_type: resource_type, data_value: result }

      var re = /edit_ride_\d+/i;
      var edit_resource = form_type.match(re);
      if (edit_resource){
        var json_data = { id: resource_id, resource_type: resource_type, data_value: result }

      }

      $.ajax({
        url : action_path,
        type : request_type,
        data : json_data
      });


      });

  }, false);




$(document).ready(function() {
  console.log("page has loaded!");
});

  $(document).ready(function() {
    
    // Cloudinary jQuery integration library uses jQuery File Upload widget
    // (see http://blueimp.github.io/jQuery-File-Upload/).
    // Any file input field with cloudinary-fileupload class is automatically
    // wrapped using the File Upload widget and configured for Cloudinary uploads.
    // You can further customize the configuration using .fileupload method
    // as we do below.
    $(".cloudinary-fileupload")
      .cloudinary_fileupload({
        // Uncomment the following lines to enable client side image resizing and valiation.
        // Make sure cloudinary/processing is included the js file
        //disableImageResize: false,
        //imageMaxWidth: 800,
        //imageMaxHeight: 600,
        //acceptFileTypes: /(\.|\/)(gif|jpe?g|png|bmp|ico)$/i,
        //maxFileSize: 20000000, // 20MB
        dropZone: "#direct_upload",
        start: function (e) {
          $(".status").text("Starting upload...");
        },
        progress: function (e, data) {
          $(".status").text("Uploading... " + Math.round((data.loaded * 100.0) / data.total) + "%");
        },
        fail: function (e, data) {
          $(".status").text("Upload failed");
        }
      })
      .off("cloudinarydone").on("cloudinarydone", function (e, data) {
        $("#photo_bytes").val(data.result.bytes);
        $(".status").text("");
        var preview = $(".preview").html('');
        $.cloudinary.image(data.result.public_id, {
          format: data.result.format, width: 50, height: 50, crop: "fit"
        }).appendTo(preview);

        $('<a/>').
          addClass('delete_by_token').
          attr({href: '#'}).
          data({delete_token: data.result.delete_token}).
          html('&times;').
          appendTo(preview).
          click(function(e) {
            e.preventDefault();
            $.cloudinary.delete_by_token($(this).data('delete_token')).done(function(){
              $('.preview').html('');
              $('#info').html('');
              $("#photo_bytes").val('');
              $('input[name="photo[image]"]').remove();
              $('.status').text("Deleted image");
            }).fail(function() {
              $('.status').text("Cannot delete image");
          });
        });
        view_upload_details(data.result);
      });
    });
    
    function view_upload_details(upload) {
      // Build an html table out of the upload object
      var rows = [];
      $.each(upload, function(k,v){
        rows.push(
          $("<tr>")
            .append($("<td>").text(k))
            .append($("<td>").text(JSON.stringify(v))));
      });
      $("#info").html(
        $("<div class=\"upload_details\">")
          .append("<h2>Upload metadata:</h2>")
          .append($("<table>").append(rows)));
    }
*/

