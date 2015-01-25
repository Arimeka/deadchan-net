$(document).on('page:fetch', function() {
  $('.loading').show();
});
$(document).on('page:change', function() {
  $('.loading').hide();
});
