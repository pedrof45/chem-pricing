class BuildXlsx < PowerTypes::Command.new(:quotes)

  def perform
    add_headers_row
    @quotes.each_with_index { |q, i| build_row(q, i + 1) }
  #   workbook = RubyXL::Parser.parse(Rails.root.join("sdp.xlsx"))
  #   worksheet = workbook[0]
  #   #worksheet[5][1].change_contents("", worksheet[5][1].formula) # Sets value of cell A1 to empty string, preserves formula
  #   worksheet[0][2].change_contents(17)
    book.save(filename)
    filename
  end

  def add_headers_row
    headers = Quote.xls_fields.keys.map { |field| hts.field_to_pt('quote', field) }
    headers.each_with_index do |header, col|
      sheet.add_cell(0, col, header)
    end
  end



  def build_row(quote, row_index)
    Quote.xls_fields.keys.each_with_index do  |field, col_index|
      value = if field.to_s.include? '.'
                f_model, f_field = field.to_s.split '.'
                quote.send(f_model).try(f_field)
              elsif enum_cols && enum_cols.include?(field.to_s)
                hts.enum_field_to_pt('quote', field, quote.send(field))
              else
                quote.send(field)
              end
      sheet.add_cell(row_index, col_index, value)
    end
  rescue StandardError => e
    binding.pry
  end

  def book
    @book ||= RubyXL::Workbook.new
  end

  def sheet
    @sheet ||= book[0]
  end

  def hts
    @hts ||= HeaderTranslatorService.new
  end

  def enum_cols
    @enum_cols ||= Quote.enumerized_attributes.attributes.keys
  end

  def filename
    timestamp = Time.current.strftime('%Y-%m-%d_%l_%M_%S')
    "quotes-#{timestamp}.xlsx"
  end
end