// $.cloudinary.config({ cloud_name: 'dijs1yfba', api_key: '488196417269728'});

// $(document).ready(function() {
//   var uploaderElements = document.getElementsByTagName("upload_image");
  
//   for (var i=0; i < uploaderElements.length; i++){
//     var element = uploaderElements[i]
//     var uploadWidget = element.firstElementChild;
//     var imagePreview = element.lastElementChild;
//     //debugger;
//     uploadImage(uploadWidget, imagePreview);
//   };
  
// });


// uploadImage = function(uploadWidget, imagePreview){
//   debugger;
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
//     bsGrid.className = "col-xs-12 col-sm-12 col-md-12 col-lg-3"
//     //public id => "preset_folder/vbq2nef9th8hyxvxnhai"
//     //after split and pop => vbq2nef9th8hyxvxnhai
//     var image_id = imageMetadata.public_id.split("/").pop();
//     bsGrid.id = image_id;
//     preview.appendChild(bsGrid);
//     debugger;
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
//       html('&times;')

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

// processResponse =  function(result, image_type){
//     //Can we make it more generic so that in ride and rider and Owner
//     // both case we could use it
//     //debugger;
//     var form_type = $("[class^=simple_form]").attr('id');
//     var resource_id = form_type.split('_').splice(-1)[0];
//     var action_path = "/images/park_images";
//     var request_type = "post";
//     var resource_type = "Owner";
//     var re = /edit_owner_\d+/i;
//     var edit_ride = form_type.match(re);

    

//     if (form_type == "new_owner"){
//       var json_data = { image_type: image_type, resource_type: resource_type, data_value: result }
//       saveResponse(action_path, request_type, json_data);
//     } else if ( edit_ride ){
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