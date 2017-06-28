require 'csv'

csv_text = File.read(Rails.root.join('db', 'countries.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')
csv.each do |row|
  country = Country.find_or_create_by(code: row[1], name: row[0])
  #puts "#{country.name}, #{country.code} saved"
end

csv_text = File.read(Rails.root.join('db', 'cities.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')
csv.each do |row|
  city = City.find_or_create_by(code: row[1], name: row[0])
  #puts "#{city.name}, #{city.code} saved"
end

csv_text = File.read(Rails.root.join('db', 'products.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'UTF-8')
csv.each do |row|
  product = Product.find_or_create_by(ncm: row[7], origin: row[6], resolution13: row[5], density: row[4],ipi: row[3], unit: row[2],name: row[1], sku: row[0])
  #puts "#{product.name}, #{product.sku} saved"
end


{ pis_confins: 0.04, interest_2_30: 0.01, interest_31_60: 0.02, interest_more_60: 0.03 }.each do |name, value|
  sys_var = SystemVariable.find_or_create_by(name: name)
  sys_var.update(value: value) if sys_var.value.nil?
end