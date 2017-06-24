require 'roo'

class UploadParserService < PowerTypes::Service.new(:data)

  def run
    sheet = Roo::Spreadsheet.open(@data)
    sheet.parse(header_search: ["field1", "field2", "field3"])

  rescue StandardError => e
    erros.add(:file, "Erro ao ler arquivo: #{e}")
  end
end
