$(function() {

  $("#vn_rating_number").ionRangeSlider({
    min: 0,
    max: 10,
    from: 5,

  });
  $("#vn_release_date").ionRangeSlider({
    min: 1995,
    max: 2020,
    from: 2000,
    to: 2010,
  });

});