# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

show_hip = (btn) ->
  $('#hip').show(1000)
  $('#hip_toggle').hide()

setup_hip = () ->
  $('#hip_toggle').click(show_hip)
  $('#hip').hide()

raffle_start = () ->
  if $('#raffle_winner')
    setTimeout(raffle_show_teaser, 3000)
    setTimeout(raffle_show_winner, 8000)

raffle_show_teaser = () ->
  $('#raffle_winner_body').show(1000)

raffle_show_winner = () ->
  $('#raffle_winner').show(1000)

$(setup_hip);
$(raffle_start);
