
function toggleFreightSubtypeInputs() {
  var f_type = $('#quote_freight_base_type_input input:checked').val();
  $('.bulk-subtype-input').parent().toggle(f_type === 'bulk');
  $('.packed-subtype-input').parent().toggle(f_type === 'packed');
}

function toggleVehicleInput() {
  var f_type = $('#quote_freight_base_type_input input:checked').val();
  var s2_subtype = $('.' + f_type + '-subtype-input').select2('data');
  var f_subtype;
  if(s2_subtype !== null) {
    f_subtype = s2_subtype['id'];
  }
  var show_vehicle = ((f_type === 'bulk' && (f_subtype === 'normal' || f_subtype === 'product')) || (f_type === 'packed' && f_subtype === 'special'));
  $('#quote_vehicle_input').toggle(show_vehicle);
}

$(function () {
  $('#quote_freight_base_type_bulk, #quote_freight_base_type_packed').change(function () {
    toggleFreightSubtypeInputs();
    toggleVehicleInput();
  });

  $('[id="quote_freight_subtype_input"]').change(function () {
    toggleVehicleInput();
  });

  $('form.quote').submit(function () {
    var f_type = $('#quote_freight_base_type_input input:checked').val();
    $('#quote_freight_subtype:not(.' + f_type + '-subtype-input)').remove();
    return true;
  });

  toggleFreightSubtypeInputs();
  toggleVehicleInput();
});
