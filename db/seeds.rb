
{ pis_confins: 0.04, interest_2_30: 0.01, interest_31_60: 0.02, interest_more_60: 0.03 }.each do |name, value|
  sys_var = SystemVariable.find_or_create_by(name: name)
  sys_var.update(value: value) if sys_var.value.nil?
end