class TaxService < PowerTypes::Service.new

  def icms_for(customer, product, origin_city_code, destination_city_code)
    rule = icms_rule_for(customer, product, origin_city_code, destination_city_code)
    return rule.value if rule
    orig_state_code = origin_city_code[0..1] if origin_city_code.present?
    dest_state_code = destination_city_code[0..1] if destination_city_code.present?
    IcmsTax.tax_value_for(orig_state_code, dest_state_code)
  end

  def pis_confins_for(customer, product)
    rule = pis_confins_rule_for(customer, product)
    return rule.value if rule
    SystemVariable.get :pis_confins
  end

  private

  def icms_rule_for(customer, product, origin_city_code, destination_city_code)
    mrs = matching_icms_rules(customer, product, origin_city_code, destination_city_code)
    mrs.sort.reverse.first
  end

  def matching_icms_rules(customer, product, origin_city_code, destination_city_code)
    customer ||= 0
    product ||= 0
    origin_city_code ||= ""
    destination_city_code ||= ""

    ir = TaxRule.icms
    rules = ir.orig_city_match(origin_city_code)
              .or(ir.dest_city_match(destination_city_code))
              .or(ir.orig_state_match(origin_city_code[0..1]))
              .or(ir.dest_state_match(destination_city_code[0..1]))
              .or(ir.customer_match(customer))
              .or(ir.product_match(product))
  end

  def pis_confins_rule_for(customer, product)
    c_and_p_rule = TaxRule.pis_confins.find_by(customer: customer, product: product)
    return c_and_p_rule if c_and_p_rule.present?
    p_rule = TaxRule.pis_confins.find_by(customer: nil, product: product)
    return p_rule if p_rule.present?
    # c_rule
    TaxRule.pis_confins.find_by(customer: customer, product: nil)
  end
end
