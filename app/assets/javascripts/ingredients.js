$(document).on('turbolinks:load', function() {
   $('.modal').modal();

   // Gets and renders the ingredient form.
   $('.new-ingredient').click(function () {
     $.get({url:'ingredients/new', dataType: "script"});
   });

   // Make a POST request to submit the import ingredient form.
   $('#import-form').submit(function (){
    $.post($(this).attr('action'), $(this).serialize(), null, "script");
    return false;
   });

   // Makes a POST request to submit the ingredient form.
   $('#ingredient-submit-btn').on('click', function() {
     $.post($('#ingredient-form').attr('action'), $('#ingredient-form').serialize(), null, "script");
   });
   enable_form_loader_listener();
 });

// Enables the callbacks for the ingredient buttons.
// This function needs to be enabled for any new ingredient that gets added to
// the list. 
enable_form_loader_listener = function() {
  $('.edit-ingredient-btn').click(function() {
    $.get({url: $(this).attr("data-edit-url"), dataType: "script"});
  });

  $('.delete-ingredient').change(function() {
    $.ajax({type: "delete", url: $(this).attr("data-edit-url"), dataType: "script"});
  });

}
