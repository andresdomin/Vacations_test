$(document).ready(function() {
  $(".form-login").validate({
    errorElement: 'span',
    errorPlacement: function(error, element) {
      element.parents('.control-group').addClass("error");
      error.addClass('help-inline');
      element.parents('.controls').append(error);
    },
    submitHandler: function(form) {
      $('.btn-login').addClass("loading disabled");
      $('.btn-login').val("Verificando usuario...");
      form.submit();
    }
  });
});