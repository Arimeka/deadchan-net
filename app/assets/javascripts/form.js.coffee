$(document).ready ->
  $('.upload-file').click ->
    $('#fileupload').click()
          
  $("#fileupload").change ->
    $(".uploading-filename").html($("#fileupload").val())

  $('button#answer').click ->
    $container = $(@).closest('.form-answer')
    $btnHide = $container.find('button#hide')

    $(@).toggle()
    $btnHide.toggle()

    $('#form').clone().insertAfter($btnHide).show()

  $('button#hide').click ->
    $container = $(@).closest('.form-answer')

    $(@).toggle()
    $container.find('button#answer').toggle()

    $container.find('#form').remove()