
showSchedule = function(startTime, endTime){
  
  var formatedStartTime = startTime.format("Do MMMM YYYY, h:mm a");
  var formatedEndTime = endTime.format("Do MMMM YYYY, h:mm a");


  document.getElementById("schedule-start").innerHTML = formatedStartTime;
  document.getElementById("schedule-end").innerHTML = formatedEndTime;
};

Number.prototype.between = function(lb, ub) {
    var min = Math.min.apply(Math, [lb, ub]);
    var max = Math.max.apply(Math, [lb, ub]);
    return this >= min && this <= max ;
};

computeDuration = function(startTime, endTime){
  // Get hours, days, and weeks from duration object
  // moment.duration().hours() gets the hours (0 - 23)
  // moment.duration().days() gets the days (0 - 29)
  // same for weeks, weeks are counted as a subset of the days
  // So added a path to substract weeks from days (if block; could have been handeled better?)
  

  var duration = moment.duration(endTime.diff(startTime));
  
  var hours = Math.round( duration.hours() );
  var days  = Math.round( duration.days() );
  var weeks = Math.round( duration.weeks() );

  if (weeks > 0){
    days = days%7
  }
  //any duration greter than 3 hr will be trated as a day
  if (hours > 3){
    days = days + 1
    hours = 0
  }

  return {
        hours: hours,
        days: days,
        weeks: weeks
    };
};

Number.prototype.humaines = function(value, unit){
  if ( value > 1) unit += "s"
  return value + " " + unit + " "
};

showDuration = function(startTime, endTime){
  //"Format" is a good libreary but I dont need that so i write mt own
  var duration = computeDuration(startTime, endTime);   
  var hours = duration.hours;
  var days = duration.days;
  var weeks = duration.weeks;
  var humaines_msg = "";

  if ( weeks > 0) humaines_msg += weeks.humaines(weeks, "week");
  if ( days > 0) humaines_msg += days.humaines(days, "day");
  if ( hours > 0) humaines_msg += hours.humaines(hours, "hour");
  
  document.getElementById("rent-duration").innerHTML = humaines_msg;
};

onDemandDuration = function(startTime, endTime, breakups){
  debugger
  // Once get the duration of hour, day, week of rent,
  // Retrive rate of each type rent duration and calculate the Rent
  // Rent calculation is easy: multiply each duration by corresponding duration 
  
  // var duration = moment.duration(endTime.diff(startTime));
  // var hours = Math.round( duration.hours() );
  // var days  = Math.round( duration.days() );
  // var weeks = Math.round( duration.weeks() );

  // if (weeks > 0){
  //   days = days%7
  // }
 
  var duration = computeDuration(startTime, endTime);   
  var rent = 0;

  if (duration.hours.between(3, 24)){
    duration.days = duration.days + 1
    duration.hours = 0;
  };

  if (duration.days == 7){
    duration.weeks = duration.weeks + 1;
    duration.days = 0;
  }



  if (duration.hours.between(1, 3)){
    //Per hour rate applicable ==> change to daily rate 
    //Now it will chargable for as a day TBD  
    var rate = parseInt( document.getElementById("slot").getElementsByTagName('h1')[0].textContent );
    var rent = rent + (rate * 1); 
    
    
    breakups.custom.hours =  {
      duration: duration.hours.humaines(duration.hours, "hour"),
      unit: "slot",
      rate: rate,
      rent: (rate * duration.hours)
    };
  }
  
  if (duration.days.between(1, 6)){
    // get Daily rate from the dom
    debugger;
    var rate = parseInt( document.getElementById("days").getElementsByTagName('h1')[0].textContent );
    var rent = rent + (rate * duration.days);
   
    breakups.custom.days =  {
      duration: duration.days.humaines(duration.days, "day"),
      unit: "day",
      rate: rate,
      rent: (rate * duration.days)
    };
  }
  if (duration.weeks.between(1, 500)){
    // 500 weeks is just a large number; a work arround, unless max limit is set
    // need to limit maximum booking duation
    // Weekly rate
    var rate = parseInt( document.getElementById("weekly").getElementsByTagName('h1')[0].textContent );
    var rent = rent + (rate * duration.weeks);

    breakups.custom.weeks =  {
      duration: duration.weeks.humaines(duration.weeks, "week"),
      unit: "week",
      rate: rate,
      rent: (rate * duration.weeks)
    };
  }
  
  return { 
    rent: rent,
    breakups: breakups
  };


};

computeRental = function(startTime, endTime, slotType){
  // Get the rent rate from page element, based of slot type
  // now morning and evening slot has same fare
  
  //var duration = getRentDuration(startTime, endTime);
  //var duration = moment.duration(startTime.diff(endTime));

  debugger;
  var breakups= { };
  switch (slotType){
    case "morning_slot":
      var duration = computeDuration(startTime, endTime);
      var rate = parseInt( document.getElementById("slot").getElementsByTagName('h1')[0].textContent );
      var rent = duration.hours*rate;
      //breakups += "Morning Slot @" + rate + "/slot"
      
      var slotType = breakups.morning_slot = {} ;
      slotType.slot =  {
        duration: duration.hours.humaines(duration.hours, "hour"), 
        unit: "slot", //duration.hours.humaines(duration.hours, "hour")
        rate: rate,
        rent: rent
      };
      break;
    case "evening_slot":
      var duration = computeDuration(startTime, endTime);

      var rate = parseInt( document.getElementById("slot").getElementsByTagName('h1')[0].textContent );
      var rent = duration.hours*rate;
      var slotType = breakups.evening_slot = {};
      slotType.slot =  {
        duration: duration.hours.humaines(duration.hours, "hour"), 
        unit: "slot",
        rate: rate,
        rent: rent
      };
      break;
    case "daily_slot":
    debugger;
      /*var duration = computeDuration(startTime, endTime);*/
      // As per rule daily_slot time is 6 am to 8 pm
      // of the same day
      // So we will consider duration as 1 day, if slot type is "daily_slot"
      // 14 hour duration is considered as 1 day  
      var duration = 1 //day

      var rate = parseInt( document.getElementById("days").getElementsByTagName('h1')[0].textContent );
      var rent = duration*rate;

      var slotType = breakups.all_day = {};
      slotType.day =  {
        duration: duration.humaines(duration, "day"), 
        unit: "day",
        rate: rate,
        rent: rent
      };
      break;

    case "weekly_slot":
    debugger;
      /*var duration = computeDuration(startTime, endTime);*/
      // As per rule daily_slot time is 6 am to 8 pm
      // of the same day
      // So we will consider duration as 1 day, if slot type is "daily_slot"
      // 14 hour duration is considered as 1 day  
      var duration = 1 //week

      var rate = parseInt( document.getElementById("weekly").getElementsByTagName('h1')[0].textContent );
      var rent = duration*rate;

      var slotType = breakups.all_day = {};
      slotType.day =  {
        duration: duration.humaines(duration, "week"), 
        unit: "week",
        rate: rate,
        rent: rent
      };
      break;  
    case "custom":
      breakups.custom= {};
      var rent_breakups = onDemandDuration(startTime, endTime, breakups);
      var rent = rent_breakups.rent;
      var breakups = rent_breakups.breakups;
      break;
    default:  
      console.log("should not see this")
  }
  
  return {
    rent: rent,
    breakups: breakups
  };
};

showRentalAmount = function(rentAmount){
  document.getElementById("ride-fare").innerHTML = rentAmount;
  document.getElementById("total-fare").innerHTML = "Total: " + rentAmount;
};

showRentalBreakup = function(rentBreakups){
  //humainesRentBreakup
  var slotType = Object.keys(rentBreakups);
  var rentTypes = Object.keys(rentBreakups[slotType]);
  var div = document.getElementById("fare-breakup")
  var msg = "";
  function rentalBreakup(rentType, index, array) {
    var rentDetails = rentBreakups[slotType][rentType];
    //2 Weeks @ $70.00 / week $1200
    msg = msg + rentDetails.duration + ' @ Rs.' + rentDetails.rate + ' /' + rentDetails.unit + ' = ' + rentDetails.rent + '</br>'
  }

    rentTypes.forEach(rentalBreakup);
    div.innerHTML = msg;


  // for (var rentType in rentTypes) {
  //   rentTypes[rentType]
  //   var rentDetails = rentBreakups[slotType].rentTypes[rentType];
  //   //2 Weeks @ $70.00 / week $1200
  //   var msg = rentDetails.duration + ' @ Rs.' + rentDetails.rate + ' / ' + rentDetails.unit + ' ' + rentDetails.rent 
  //   var div = document.getElementById("fare-breakup")
  //   div.innerHTML = div.innerHTML + msg;
  // };

  
};

showRental = function(startTime, endTime, slotType){
  var rentBreakups = computeRental(startTime, endTime, slotType);
  var rentAmount = rentBreakups.rent;
  var rentBreakups = rentBreakups.breakups;

  showRentalAmount(rentAmount);
  showRentalBreakup(rentBreakups);
  
};
getSlotType = function (schedule){
  // TBD Slot type should set by name rather than bool (in model)
  // Then could eliminate this nasty check
  debugger;
  var slotType;
  if (schedule.morning_ride){
    slotType = "morning_slot";
  } else if (schedule.evening_ride){
    slotType = "evening_slot";
  } else if (schedule.weekly_ride){
    slotType = "weekly_slot";
  } else if (schedule.daily_ride){
    slotType = "daily_slot";
  } else {
    slotType = "custom";
  }
  return slotType;
};
setScheduleID = function(id){
  document.getElementById("schedule_id").innerHTML = id;
}

bookSlot = function(schedule){
  debugger;
  toogle_reservation_form(); 
  //Enable the booking button
  document.getElementById("book_my_bike").disabled = false;

  console.log(schedule)
  //Get start time and event end time from Moment object
  // and ploting 'em in the booking view

  var slotType = getSlotType(schedule);
  var startTime = schedule.start;
  var endTime = schedule.end;
  setScheduleID(schedule.id);
  showSchedule(startTime, endTime);
  showDuration(startTime, endTime);
  showRental(startTime, endTime, slotType);
  //TBD showRentalBreakup
  console.log("going to do slot")
};
