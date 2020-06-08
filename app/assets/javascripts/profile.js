$(document).on("turbolinks:load", function(){
  $('.timeslots').on('click', function(){
    var id = $(this).attr('id').substring(8);
    if ($(this).prop("checked")){
      var key = new Date().getTime();
      $('<input>').attr('type', 'hidden').attr('class', 'cancel_hidden_' + id).attr('name', 'booking[update_bookings][' + key + '][booking_id]').val($(this).val()).appendTo('.booking_form');
    }else{
      $('.cancel_hidden_'+ id).remove();
    }
    if ($('#cancel_form input:hidden').length > 2) {
      $("#cancel_button").prop('disabled', false);
      var form_data_email = validate_email($(".email_field").val());
      if (form_data_email){
        $("#transfer_button").prop('disabled', false);
      }
    }else{
      $("#cancel_button, #transfer_button").prop('disabled', true);
    }
  });

  $('#transfer_booking').on('click', function(){
    $.ajax({
      beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
      url:"/bookings/transfer_form",
      dataType: 'script'
    });
  });

  $(".email_field").on('input', function(){
    var form_data_email = validate_email($(this).val());
    if (form_data_email && $('#cancel_form input:hidden').length > 2){
      $("#transfer_button").prop('disabled', false);
    }else{
      $("#transfer_button").prop('disabled', true);
    }
  });

  function validate_email(email){
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
  }

  $("#cancel_button").on('click', function(){
    if (confirm('Are you sure you want to cancel the checked bookings?')){
      $('#cancel_form').submit();
    }
  });

  $("#transfer_button").on('click', function(){
    if (confirm('Are you sure you want to trasnfer the checked bookings?')){
      $('#transfer_form').submit();
    }
  });
});
