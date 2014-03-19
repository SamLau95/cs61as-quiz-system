# Handles auto resizing for textareas

ready = ->
  txt = $("textarea[id^=quiz_questions_]")
  hiddenDiv = $(document.createElement("div"))
  content = null

  txt.addClass "txtstuff noscroll"
  hiddenDiv.addClass "hiddendiv common"
  $("body").append hiddenDiv
  txt.on "keyup", ->
    content = $(this).val()
    content = content.replace(/\n/g, "<br>")
    hiddenDiv.html content + "<br class=\"lbr\">"
    $(this).css "height", hiddenDiv.height() + 25

$(document).ready ready
$(document).on 'page:load', ready
