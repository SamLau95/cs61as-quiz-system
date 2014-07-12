onchange = ->
  $.ajax
    url: gon.lock_path,
    type: 'POST'

fullscreen = ->
  $('#fullscreen').click (e) ->
    e.preventDefault()
    docElement = document.documentElement
    request = docElement.requestFullscreen or docElement.webkitRequestFullscreen or docElement.mozRequestFullscreen or docElement.msRequestFullscreen
    request.call docElement if typeof request isnt "undefined" and request
    $('#quiz').show()
    $('#fullscreen').hide()
    $('li.name').hide()
    fs = 'webkitfullscreenchange mozfullscreenchange fullscreenchange'
    fullScreen = false
    $(document).on fs, (e) ->
      fullScreen = !fullScreen
      if !fullScreen
        $.ajax
          url: gon.lock_path,
          type: 'POST'

  $('.hilite').keydown (e) ->
    if (e.keyCode == 9)
      start = this.selectionStart
      end = this.selectionEnd
      $this = $(this)
      $this.val($this.val().substring(0, start) + "\t" + $this.val().substring(end))
      this.selectionStart = this.selectionEnd = start + 1
      return false

hilite = ->
  $('.hilite').keyup (e) ->
    HighlightLisp.highlight_element(e.target)

hilite_answer = ->
  answers = $('.replace')
  for i in [0...answers.length]
    HighlightLisp.highlight_element(answers[i])

ready = ->
  if $('#take_quiz_form').length
    fullscreen()
    $(window).blur -> onchange()
    timer(gon.time_left)
    hilite()
    $('#take_quiz_form').sisyphus()
  else if $('#show_quiz').length
    hilite_answer()
  else
    $(window).off 'blur'



#Countdown timer:

timer = (time) ->
  if time > 0
    [minutes, seconds] = [parseInt(time / 60), time % 60]
    $(".seconds").html("#{seconds} second(s)")
    $(".minutes").html("#{minutes} minute(s)")
    setTimeout (-> timer(time - 1)), 1000
  else
    $(".seconds").html("0 second(s)")
    console.log 'Out of time!'
    $("#submit_quiz").click()

$(document).ready ready
$(document).on 'page:load', ready
