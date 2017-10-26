$(document).ready ->
  $('.message').on 'click', (e) ->
    $(e.target.parentElement).fadeOut 500, 'swing', false

  setTimeout ->
    $('.flash').fadeOut 500, 'swing', false
  , 3500