$(document).ready(function() {
  function closeSidenav() {
    $('#sidenav').addClass('sidenav-hidden');
  }

  function openSidenav() {
    $('#sidenav').removeClass('sidenav-hidden');
  }

  $('#sidenav-open-button').click(openSidenav);
  $('#content').click(closeSidenav);
});
