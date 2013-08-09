$(document).ready(function() {
      $.ajaxSetup ({
          // Disable caching of AJAX responses
          cache: false
      });

      if($("#requestsTable").length > 0) {
        $("#requestsTable").dataTable({
            "bJQueryUI": true,
            "bLengthChange": false,
            "sPaginationType": "full_numbers",
            "aaSorting": [ [ 4, "desc" ] ],
            "sDom": '<"H"Tfr>t<"F"ip>',
            "oTableTools": {
              "sSwfPath": "/swf/copy_csv_xls_pdf.swf",
              "aButtons": [
                "xls"
              ]
            }
        });
      }
      var dates = $('#request_begin_at, #request_end_at').datepicker({
          dateFormat: 'yy/mm/dd',
          minDate: 0,
          onSelect: function(selectedDate) {
            var option = this.id == "request_begin_at" ? "minDate" : "maxDate";
            var instance = $( this ).data( "datepicker" );
            var date = $.datepicker.parseDate(instance.settings.dateFormat || $.datepicker._defaults.dateFormat, selectedDate, instance.settings );
            dates.not( this ).datepicker( "option", option, date );
            calculate_days();
            range_check();
          }
      });

    $("#request_pay_days").change(function() {
      var paydays = $(this).val();
      $("#paydays_letter").hide();
      if(paydays > 0) {
        $("#paydays_letter").show();
      }
    });

    $(".form-requests").validate({
      errorElement: 'span',
      errorPlacement: function(error, element) {
        element.parents('.control-group').addClass("error");
        error.addClass('help-inline');
        element.parents('.controls').append(error);
      },
      rules: {
          "request[pay_days]": {
              min: 0,
              max: function() {
                var maxPayDays = Math.floor($("#available_days").val() / 2) - 1;
                var limit = $('#available_days').val() - maxPayDays;
                var days = $("#request_days").val();
                if(days < limit) {
                  maxPayDays = days - 1;
                }
                return maxPayDays;
              }
          },
          "request[days]": {
              min: function(){
                if($("#request_begin_at").val() == "2013/03/26" && $("#request_end_at").val() == "2013/03/27"){
                  return 2;
                }
                return 3;
              },
              max: function() {
                  var maxDays = $("#available_days").val() - $("#request_pay_days").val();
                  return maxDays;
              }
          },
          "request[pay_days_approved]": {
              min: 0,
              max: function() {
                var maxPayDays = Math.floor($("#available_days").val() / 2) - 1;
                var limit = $('#available_days').val() - maxPayDays;
                var days = $("#request_days").val();
                if(days < limit) {
                  maxPayDays = days - 1;
                }
                return maxPayDays;
              }
          },
          "request[days_approved]": {
              min: function(){
                if($("#request_begin_at").val() == "2013/03/26" && $("#request_end_at").val() == "2013/03/27"){
                  return 2;
                }
                return 3;
              },
              max: function() {
                  var maxDays = $("#available_days").val() - $("#request_pay_days").val();
                  return maxDays;
              }
          },
          "leader_name_": "required",
          "request[approver_email]": "required"
      },
      submitHandler: function(form) {
        $('.btn-accept').addClass("loading disabled");
        $('.btn-accept').val("Enviando solicitud...");
        form.submit();
      }
    });



  $(function() {  

      $( "#leader_name" ).autocomplete({  
          source: RAILS_PATH + "/requests/autocomplete",
          minLength: 2,
          select: function( event, ui ) {
            $( "#leader_name" ).val( ui.item.name);
            $("#request_approver_email").val(ui.item.email);
            return false;
          },
          change: function(event, ui) {
              if (ui.item == null) {
                  $('#send').attr('disabled', 'true');
                  $('#error_container').html('<span id="error_info" class="alert alert-error">En el campo "Nombre del jefe inmediato", debe seleccionar el nombre de la lista desplegable</span>');
              } else {
                  $('#send').removeAttr('disabled');
                  $('#error_info').remove();
              }
          }
      }).data( "autocomplete" )._renderItem = function( ul, item ) {
          
          return $( "<li></li>" )
            .data( "item.autocomplete", item )
            .append( "<a class='item_name_autocomplete'>" + item.name + "</a>" + "<a class='item_position_autocomplete'>" + item.position + "</a>" + "</br>" )
            .appendTo( ul );
      };

      


    });
        
    $("#request_pay_days").change(function() {
        var paydays = $(this).val();
        if(paydays > 0) {
          $('#send').attr('disabled',true);
          $('#send').attr('value','No puede solicitar vacaciones');
        }else{
            $('#send').attr('disabled',false);
            $('#send').attr('value','Enviar');
        }
    });
    
    $("#request_letter_file").change(function(){
        if ($("#request_letter_file").val()!=""){
          $('#send').attr('disabled',false);
          $('#send').attr('value','Enviar');
        }else{
          $('#send').attr('disabled',true);
          $('#send').attr('value','No puede solicitar vacaciones');
        }
    });

      $("#confirm").click(function(){
        var begin = $("#request_begin_at").val();
        var end = $("#request_end_at").val();
        var retrn = $("#return").val();
        var request_days = $("#request_days").val();

        $('#begin').html(begin);
        $('#end').html(end);
        $('#returning').html(retrn);
        $('#requested').html(request_days);
      });



});
function calculate_days() {
    var begin_at = $("#request_begin_at").val();
    var end_at = $("#request_end_at").val();
    if(begin_at != '' && end_at != '') {
        $.getJSON(RAILS_PATH + '/holidays/calculate_days', { date_begin: begin_at, date_end: end_at }, function(response) {
            var days = response.days - response.holidays+1;
            if (response.deduct_day === true){
              days += 1;
            }
            $('#request_days').val(days);
            $('#return').val(response.back_to_office);

        });
    }   
}
function range_check() {
    var begin_at = $("#request_begin_at").val();
    var end_at = $("#request_end_at").val();
    if(begin_at != '' && end_at != '') {
        $.getJSON(RAILS_PATH + '/requests/range_check', { date_begin: begin_at, date_end: end_at }, function(response) {
            if(!response.available_to_request){
                $('#send').attr('disabled', 'true');
                $('#error_container').html('<span id="error_info" class="alert alert-error">No puede enviar solicitud con un rango de fechas que esté entre un rango de fechas de una solicitud ya aceptada</span>');
            }else{
                $('#send').removeAttr('disabled');
                $('#error_info').remove();
            }

        });
    }
    
}
