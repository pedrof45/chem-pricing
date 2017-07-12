class UploadParserService < PowerTypes::Service.new(:u)

  def run
    @klass = Object.const_get @u.model.classify
    sheet = Roo::Spreadsheet.open(@u.file, clean: true)
    headers = hts.model_fields_to_pt(@u.model)
    hash_tables = build_hash_tables
    compare_headers(sheet, headers)

    new_entries = []
    accept_file = true
    sheet.parse(headers).each_with_index do |row, index|
      row_n = index + 2
      puts "Processing sheet row ##{row_n}" if (row_n % 100).zero?
      obj = BuildObjectFromRow.for(model: @u.model, row: row, hash_tables: hash_tables)
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
      @klass.import new_entries, on_duplicate_key_update: [:id]
      @u.records = new_entries
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

  def build_hash_tables
    hash_tables = {}
    f_key_fields = @klass.xls_fields.select {|_k, v| v == :f_key }.keys
    f_key_fields.each do |f_key_field|
      f_model, f_field = f_key_field.to_s.split('.')
      f_class = Object.const_get f_model.classify
      # hash_tables[f_key_field] = f_class.pluck(f_field, :id).map { |row| [row.first.to_s, row.last.to_s] }.to_h
      hash_tables[f_key_field] = f_class.all.map { |obj| [obj.send(f_field).to_s, obj] }.to_h
    end
    hash_tables
  end
end
