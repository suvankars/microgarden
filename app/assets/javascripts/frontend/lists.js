var updateEvent;
var display;
var refetch_events_and_close_dialog;

$(document).ready(function() {

  var dialog_form = $('<div id="dialog-form">Loading form...</div>').dialog({
    autoOpen: false,
    height: 350,
    width: 700,
    modal: true,
    buttons: {
        'Create event': function () {
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
    height: 600,
    height: 600,
    slotMinutes: 30,
    eventSources: [
      {
        url: '/lists/get_lists'
      }
    ],
    timeFormat: 'h:mm',
    dragOpacity: "0.5",

    eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc) {
      return updateEvent(event);
    },
    eventResize: function(event, dayDelta, minuteDelta, revertFunc) {
      return updateEvent(event);
    },
    eventClick: function(event, jsEvent, view){
      updateEventDetails(event);
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
  /*// alert("I am in display");
  // console.log(options["starttime"]);
  // console.log(options["endtime"]);*/
  $('#event_form').remove('');
  fetch(options);
},

render= function(options){
      $('#event_form').trigger('reset');
      
      var startTime = options['starttime']
      var endTime = options['endtime'];
      console.log(startTime);
      console.log(startTime.toLocaleString());
      console.log(startTime.toUTCString());
      console.log(startTime.toUTCString().toLocaleString());
      var type = '#schedule_start_time';
      var time = startTime
      var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
      console.log($year.val(time.getUTCFullYear()));
      $year.val(time.getFullYear());
      $month.prop('selectedIndex', time.getUTCMonth());
      $day.prop('selectedIndex', time.getUTCDate() - 1);
      $hour.prop('selectedIndex', time.getUTCHours());
      $minute.prop('selectedIndex', time.getUTCMinutes());

      //var now_utc = new Date(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate(),  now.getUTCHours(), now.getUTCMinutes(), now.getUTCSeconds());
      /* settime function is not setting values: TODO*/
      var type = '#schedule_end_time';
      var time = endTime;
      var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
      console.log($year.val(time.getFullYear()));
      $year.val(time.getFullYear());
      $month.prop('selectedIndex', time.getMonth());
      $day.prop('selectedIndex', time.getDate() - 1);
      $hour.prop('selectedIndex', time.getUTCHours());
      $minute.prop('selectedIndex', time.getUTCMinutes());

      // Defaulf checked Morning Ride 
      //$('#schedule_morning_ride').attr('checked', options['morning_ride'])
      //$('#schedule_all_day').attr('checked', options['allDay'])
      $('#create_event_dialog').dialog({
        title: 'New Event',
        modal: true,
        width: 500,
        close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
      });
},

make_it_work_setTime =  function(type, time) {
  //$('#event_form').remove('')

  var $year = $(type + '_1i'), $month = $(type + '_2i'), $day = $(type + '_3i'), $hour = $(type + '_4i'), $minute = $(type + '_5i')
  console.log($year.val(time.getFullYear()));
  $year.val(time.getFullYear());
  $month.attr('selectedIndex', time.getMonth());
  $day.attr('selectedIndex', time.getDate() - 1);
  $hour.attr('selectedIndex', time.getHours());
  $minute.attr('selectedIndex', time.getMinutes());
},

fetch = function(options){
  var list_id = $("#list").data('list').list_id
  $.ajax({
    type: 'get',
    dataType: 'script',
    async: true,
    url: "/lists/" + list_id + "/schedules/new",
    success: function(){ render(options) }
  });
},

/*fetch = function(options){
      alert("I am going to fetch");
       $('#create_event_dialog').dialog({
        title: 'New Event',
        modal: true,
        width: 500,
        close: function(event, ui) { $('#create_event_dialog').dialog('destroy') }
      });

},*/

updateEvent = function(the_event) {
  var json_data ={ event: {
      title: the_event.title,
      starts_at: "" + the_event.start,
      ends_at: "" + the_event.end,
      description: the_event.description
    }
  }
  return $.ajax({
        url : "/lists/" + the_event.id + "/availability/" ,
        type : "PATCH",
        data : json_data
      }); 
 
};

renderUpdateForm = function(){

};

updateEventDetails = function(schedule){
  alert("Going to update")
  var list_id = $("#list").data('list').list_id
  console.log(event);
  $.ajax({
        type: 'GET',
        dataType: 'script',
        async: true,
        url : "/lists/" + list_id + "/schedules/" + schedule.id + "/edit",

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
  $('#create_event_dialog, #event_desc_dialog').on('submit', "#event_form", function(event) {
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
});