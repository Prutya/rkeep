$(document).ready(function() {
  $('#shifts-table tbody tr').click(function(){
    window.location = $(this).data('href');
    return false;
  });
});
