$(document).on('turbolinks:load', function(){
  var date = new Date();
  var endDate = new Date(date.setMonth(date.getMonth()+2));
  $('.date_field').datepicker({
    format: 'dd-mm-yyyy',
    autoclose: true,
    startDate: new Date(),
    endDate: endDate
  });
});
