$(document).ready ->
  $('.upload-file').click ->
    $('#fileupload').click()
          
  $("#fileupload").change ->
    $(".uploading-filename").html($("#fileupload").val())