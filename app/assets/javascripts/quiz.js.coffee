# http://stackoverflow.com/a/1060034
addFocusListener = ->
  hidden = "hidden"
  if hidden of document
    document.addEventListener "visibilitychange", onchange
  else if (hidden = "mozHidden") of document
    document.addEventListener "mozvisibilitychange", onchange
  else if (hidden = "webkitHidden") of document
    document.addEventListener "webkitvisibilitychange", onchange
  else if (hidden = "msHidden") of document
    document.addEventListener "msvisibilitychange", onchange
  else if "onfocusin" of document
    document.onfocusin = document.onfocusout = onchange
  else
    window.onpageshow = window.onpagehide = window.onfocus = window.onblur = onchange

removeFocusListener = ->
  hidden = "hidden"
  if hidden of document
    document.removeEventListener "visibilitychange", onchange
  else if (hidden = "mozHidden") of document
    document.removeEventListener "mozvisibilitychange", onchange
  else if (hidden = "webkitHidden") of document
    document.removeEventListener "webkitvisibilitychange", onchange
  else if (hidden = "msHidden") of document
    document.removeEventListener "msvisibilitychange", onchange
  else if "onfocusin" of document
    document.onfocusin = document.onfocusout = undefined
  else
    window.onpageshow = window.onpagehide = window.onfocus = window.onblur = undefined

onchange = (evt) ->
  console.log 'The page changed focus!'

ready = ->
  if $('#take_quiz_form').length
    addFocusListener()
  else if $(".minutes").length

    #set time limit here!
    runTest(3600)

  else
    removeFocusListener()


#Countdown timer:

runTest = (time)->
  if time != 0
    [minutes, seconds] = [parseInt(time / 60), time % 60]
    $(".seconds").html("#{seconds} second(s)")
    $(".minutes").html("#{minutes} minute(s)")
    setTimeout (-> runTest(time - 1)), 1000
  else
    $(".seconds").html("0 second(s)")
    $(".small").click()

$('.small').onclick = ->


$(document).ready ready
$(document).on 'page:load', ready


