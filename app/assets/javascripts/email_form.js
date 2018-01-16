function updatePreview() {
  setTimeout(function(){
    var message = $('#email_message').val().replace(/\n/g, '<br/>');
    $('#message-place').html(message);
  }, 300);
}

$(function () {
  $('#email_submit_action input').val('Enviar Email');
  $('#email_message').change(function () {
    updatePreview();
  });
  $('#email_message').keypress(function () {
    updatePreview();
  });
});
