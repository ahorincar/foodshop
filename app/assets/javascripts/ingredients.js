$(document).on('turbolinks:load', function() {
   $('.modal').modal();

   // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
   $('.new-ingredient').click(function () {
     $.get({url:'ingredients/new', dataType: "script"});
   });

   $('#import-form').submit(function (){
    $.post($(this).attr('action'), $(this).serialize(), null, "script");
    return false;
   });

   $('#ingredient-submit-btn').on('click', function() {
     $.post($('#ingredient-form').attr('action'), $('#ingredient-form').serialize(), null, "script");
   });
   enable_form_loader_listener();
 });

enable_form_loader_listener = function() {
  $('.edit-ingredient-btn').click(function() {
    $.get({url: $(this).attr("data-edit-url"), dataType: "script"});
  });

  $('.delete-ingredient').change(function() {
    $.ajax({type: "delete", url: $(this).attr("data-edit-url"), dataType: "script"});
  });

}
