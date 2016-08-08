//For gmap auto complete

$(function() {
  var completer;
  console.log("AUTO Complete")
  completer = new GmapsCompleter({
    
      mapElem: "#gmaps-canvas", 
      zoomLevel: 4, 
      mapType: google.maps.MapTypeId.ROADMAP,
      pos: [20.5937, 78.9629],
      inputField: '#gmaps-input-address',
      errorField: '#gmaps-error',
      debugOn: false
    

  });

  completer.autoCompleteInit({
  region: 'IN', 
  country: 'India',
  zoom : 21,
  autocomplete: {
    minLength: 2,
    position: {
      my: "center top",
      at: "center bottom"
    }
  }
});
});