
rePositionMarkers = function(data){
  var data_hash = data;
      var handler = Gmaps.build('Google');
      handler.buildMap({ provider: {}, internal: {id: 'map'}}, function(){
        markers = handler.addMarkers(data_hash);
        handler.bounds.extendWith(markers);
        handler.fitMapToBounds();
    });
};
reRenderRideList = function(rides){
  //alert("Going to refresh ride list");
  //Tried out partial rendering but that re-rendering the whole partial 
  //TBD find a better way to update dom on success respose 
  $("#rides").empty();
  $(function() {
    $.each(rides, function(i, ride) {
      
      var image = ride.images[0]
      var image_url = image["thumbnail_url"]
       $('#rides').append('<hr />')

      $('<ride-ride>').append(
        $('<li class="ride"' + 'id=ride_' + ride.id + '>').append( 
          $('<a data-remote="true" href="/rides/' + ride.id + '\">').append(
            $('<div class="ride-details">').append(

              $('<div class="ride-image">').append('<img src=' + image_url +'>'),

              $('<div class="ride-body">').append(
                $('<h4 class="media-heading">').text(ride.ride_title),
-               $('<p>').text(ride.ride_description)
              )
            )
          )
        )
      ).appendTo('#rides');
    });
  });

};


//On Submit a search on map
//Reposition all available rides on map and update ride-list

$(function(){ 
  $("#ajax").click(function(){
    var valuesToSubmit = $('#gmaps-input-address').val();
    $.ajax({
        type: "GET",
        url: $(this).attr('action'),
        data: { search: valuesToSubmit},
        dataType: "JSON" 
    }).success( function(data, status, xhr){
        var rides = data["rides"];
        var geoLocation = data["hash"];
        rePositionMarkers(geoLocation);
        reRenderRideList(rides);
    });
    return false; 
  })
});  

