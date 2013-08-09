jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()
  $('.dataTables').dataTable({
    "bJQueryUI": true,
    "bLengthChange": false,
    "sPaginationType": "full_numbers"
  })