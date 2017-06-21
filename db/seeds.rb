require 'csv'

csv_text = File.read(Rails.root.join('db', 'countries.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')
csv.each do |row|
  country = Country.find_or_create_by(code: row[1], name: row[0])
  puts "#{country.name}, #{country.code} saved"
end

{ pis_confins: 0.04, interest_2_30: 0.01, interest_31_60: 0.02, interest_more_60: 0.03 }.each do |name, value|
  sys_var = SystemVariable.find_or_create_by(name: name)
  sys_var.update(value: value) if sys_var.value.nil?
end