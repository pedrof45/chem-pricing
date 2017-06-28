require 'roo'

class UploadParserService < PowerTypes::Service.new(:u)

  def run
    klass = Object.const_get @u.model.classify
    headers = klass.xls_fields
    pt_headers = headers.map { |k,v| [translate_field(k), v] }.to_h

    sheet = Roo::Spreadsheet.open(@data)
    sheet.parse(header_search: pt_headers.keys)
  end
end
