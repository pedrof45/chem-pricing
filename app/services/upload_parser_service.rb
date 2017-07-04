class UploadParserService < PowerTypes::Service.new(:u)

  def run
    @klass = Object.const_get @u.model.classify
    sheet = Roo::Spreadsheet.open(@u.file, clean: true)
    headers = hts.model_fields_to_pt(@u.model)
    compare_headers(sheet, headers)

    new_entries = []
    accept_file = true
    sheet.parse(headers).each_with_index do |row, index|
      row_n = index + 2
      obj = BuildObjectFromRow.for(model: @u.model, row: row)
      if !obj.errors.any? && obj.valid?
        new_entries << obj
      else
        accept_file = false
        obj.errors.full_messages.each do |error_msg|
          row_error(row_n, error_msg)
        end
      end
    end

    if accept_file && !@u.errors.any?
      new_entries.each { |new_entry| new_entry.save! }
      true
    else
      false
    end
  end

  def compare_headers(sheet, headers)
    diff = sheet.row(1) - headers.values
    unless diff.empty?
      error("Cabeçalho de coluna inesperado: #{diff}")
    end
  end

  def hts
    @hts ||= HeaderTranslatorService.new
  end

  def row_error(row_n, msg)
    error "Fila ##{row_n}: #{msg}"
  end

  def error(msg, attr = :base)
    @u.errors.add(attr, msg)
  end
end
