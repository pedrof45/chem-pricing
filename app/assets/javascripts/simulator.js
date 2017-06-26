
function toggleFreightSubtypeInputs() {
  var f_type = $('#quote_freight_base_type_input input:checked').val();
  $('.bulk-subtype-input').parent().toggle(f_type === 'bulk');
  $('.packed-subtype-input').parent().toggle(f_type === 'packed');
}

$(function () {
  $('#quote_freight_base_type_bulk, #quote_freight_base_type_packed').change(function () {
    toggleFreightSubtypeInputs();
  });

  $('form.quote').submit(function () {
    var f_type = $('#quote_freight_base_type_input input:checked').val();
    $('#quote_freight_subtype:not(.' + f_type + '-subtype-input)').remove();
    return true;
  });

  toggleFreightSubtypeInputs();
});
