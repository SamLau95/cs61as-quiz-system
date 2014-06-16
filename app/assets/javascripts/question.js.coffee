
preview = ->
  $('.expand').keyup (e) ->
    $(this).siblings('.preview').text($(this).val())
    console.log('type')

ready = ->
  if $('.preview').length
    preview()


$(document).ready ready
$(document).on 'page:load', ready