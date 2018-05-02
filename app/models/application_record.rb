class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.xls_fields
    self.column_names.zip([nil]).to_h.symbolize_keys
  end

  def has_been_updated?
    updated_at != created_at
  end
end
