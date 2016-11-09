$(document).ready(function() {
  $('#bills-table tr').click(function(){
    window.location = $(this).data('href');
    return false;
  });
});
