$(document).on('turbolinks:load', function(){
  var count = $("#available_slots_count").val();
  for(var i = 0; i < count; i++){
    pageSize = 10;
    var pageCount =  $(".line-content-" + i).length / pageSize;
    $("#pagin-" + i).append('<li class="page-item"><button class="prev btn btn-light btn-sm page-group-'+ i +'"" data-page-group='+ i +'> Prev </button></li>');
     for(var j = 0; j < pageCount; j++){
       $("#pagin-" + i).append('<li class="page-item"><button class="page_button btn btn-light btn-sm button-'+ (j+1) +' page-group-'+ i +'"" data-page-group='+ i +'>'+ (j+1) +'</button></li>');
     }
     $("#pagin-" + i).append('<li class="page-item"><button class="next btn btn-light btn-sm page-group-'+ i +'"" data-page-group='+ i +'> Next </button></li>');
    $("#pagin-"+ i +" .page_button").first().addClass("current");
    showPage(i, 1);
  }

  $(".timeslots").on("click", function(e){
    var id = $(this).attr('id').substring(12);
    if ($(this).prop("checked")){
      var key = new Date().getTime();
      $('<input>').attr('type','hidden').attr('name', 'booking[' + key + '][timeslot_id]').attr('value', $(this).val()).attr('class', "hidden_" + id).appendTo('#booking_form');
      $('<input>').attr('type','hidden').attr('name', 'booking[' + key + '][start_date]').attr('value', $(this).data("startDate")).attr('class', "hidden_" + id).appendTo('#booking_form');
      $('<input>').attr('type','hidden').attr('name', 'booking[' + key + '][room_id]').attr('value', $(this).data("roomId")).attr('class', "hidden_" + id).appendTo('#booking_form');
    }else{
      $(".hidden_" + id).remove();
    }
  });

  function showPage(group_id, page){
    pageSize = 10;
    $(".line-content-" + group_id).hide();
    $(".line-content-" + group_id).each(function(n){
        if (n >= pageSize * (page - 1) && n < pageSize * page)
            $(this).show();
    });
  }

  $(".card-body").on("click", ".page_button", function(){
    var group_id = $(this).data("pageGroup");
    $(".page-group-" + group_id).removeClass("current");
    $(this).addClass("current");
    showPage(group_id, parseInt($(this).text()));
  });

  $(".card-body").on("click", ".prev", function(){
    var group_id = $(this).data("pageGroup");
    var page = parseInt($("#pagin-"+ group_id + " .current").text());
    if(page > 1){
      page = page-1
      $(".page-group-" + group_id).removeClass("current");
      $(".page-group-" + group_id + ".button-"+page).addClass("current");
      showPage(group_id, page);
    }
  });

  $(".card-body").on("click", ".next", function(){
  var group_id = $(this).data("pageGroup");
    var page = parseInt($("#pagin-"+ group_id + " .current").text());
    var pageCount =  $(".line-content-" + group_id).length / 10;
    if(page < pageCount){
      page = page+1
      $(".page-group-" + group_id).removeClass("current");
      $(".page-group-" + group_id + ".button-"+page).addClass("current");
      showPage(group_id, page);
    }
  });

  $(".card-header").on("click", function(){
    var group_id = $(this).data("page");
    if ($("#collapseSlots-"+ group_id).data("status") == "close"){
      $("#collapseSlots-"+ group_id).removeClass("card-close").addClass("card-open");
      $("#collapseSlots-"+ group_id).attr("data-status", "open");
    }else if($("#collapseSlots-"+ group_id).data("status") == "open"){
      $("#collapseSlots-"+ group_id).removeClass("card-open").addClass("card-close");
      $("#collapseSlots-"+ group_id).attr("data-status", "close");
    }
  });

  $("#expand_or_collapse").on("click", function(){
    if($(this).text() == "Expand All"){
      $(this).text("Collapse All");
      $(".card-body").collapse('show');
    }else{
      $(this).text("Expand All");
      $(".card-body").collapse('hide');
    }
  });
});
