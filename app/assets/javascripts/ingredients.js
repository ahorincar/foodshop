$(document).ready(function(){
   // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
   $('.new-ingredient').click(function () {
     $.get({url:'ingredients/new', dataType: "script"});
   });
 });
