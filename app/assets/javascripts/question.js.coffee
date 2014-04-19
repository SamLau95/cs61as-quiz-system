ready = ->
  $(".addCheckBox").click ->
    $(".checkbox").append "<p> hello</p>"

  $(".addMultiChoice").click ->
    $(".multiChoice").append ""

$(document).ready ready
$(document).on 'page:load', ready