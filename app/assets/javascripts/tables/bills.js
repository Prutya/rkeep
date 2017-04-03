$(function() {
  $('#bills-table tbody tr').click(function(){
    var url = $(this).data('href');
    if (url) {
      window.location = url;
    }
  });
});
