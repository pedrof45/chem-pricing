
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

function togglePriceMarkupInput() {
  var priceFixed = $('#quote_fixed_price_true:checked').val() !== undefined;
  $('#quote_unit_price').prop('disabled', !priceFixed).toggleClass('disabled-input', !priceFixed);
  $('#quote_markup').prop('disabled', priceFixed).toggleClass('disabled-input', priceFixed);
}

function fetchMarkup() {
  var distCenterId = ($('#quote_dist_center_id').select2('data') || {}).id;
  var productId = ($('#quote_product_id').select2('data') || {}).id;
  var customerId = ($('#quote_customer_id').select2('data') || {}).id;
  var url = '/quotes/fetch_markup.json';
  $.ajax({
    type: "GET",
    dataType: "script",
    url: url,
    data: {
      dist_center_id: distCenterId,
      product_id: productId,
      customer_id: customerId
    },
    complete: function(data, textStatus, jqXHR){
      if((data === undefined) || (data.responseText === undefined)) { return; }
      var respObj = JSON.parse(data.responseText);
      var tableValue = (respObj || {}).table_value
      if(tableValue !== undefined) {
        $('#quote_markup').val(tableValue)
      }
    }
  });
}

function toggleCityInput() {
  var hasCustomer = !!$('#quote_customer_id').select2('data');
  var redispatchSelected = $('#quote_freight_condition_redispatch').is(':checked');
  var enableCity = !hasCustomer || redispatchSelected;
  $('#quote_city_id').prop('disabled', !enableCity);
}

function toggleFreightInputs() {
  var fobSelected = $('#quote_freight_condition_fob').is(':checked');
  $('#quote_freight_subtype, #quote_vehicle_id, .freight-fieldset input:radio').prop('disabled', fobSelected);
  $(".freight-fieldset").toggleClass('disabled-input', fobSelected)
}

function fakeSimulatorSelect() {
  $('li#quotes').removeClass('current');
  $('li#simulator').addClass('current');
}

$(function () {
  $('.base-field-input').change(function () {
    fetchMarkup();
  });

  $('#quote_customer_id, #quote_freight_condition_input').change(function () {
    toggleCityInput();
    toggleFreightInputs();
  });

  $('#quote_fixed_price_true, #quote_fixed_price_false').change(function () {
    togglePriceMarkupInput();
  });

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
  togglePriceMarkupInput();
  toggleCityInput();
  if($('#page_title').html() === 'Simulador de Preço') {
    fakeSimulatorSelect();
  }

});
