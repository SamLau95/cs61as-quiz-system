ready = ->
  onchange = (evt) ->
    v = "visible"
    h = "hidden"
    evtMap =
      focus: v
      focusin: v
      pageshow: v
      blur: h
      focusout: h
      pagehide: h

    evt = evt or window.event
    console.log 'They changed the page!'

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
  return

$(document).ready ready
$(document).on 'page:load', ready