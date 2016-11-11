$(document).ready(function() {
  $('#bills-table tbody tr').click(function(){
    window.location = $(this).data('href');
    return false;
  });
});
