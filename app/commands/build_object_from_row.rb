class BuildObjectFromRow < PowerTypes::Command.new(:model, :row)
  def perform
    @klass = Object.const_get @model.to_s.classify
    @obj = build_obj
    @obj.assign_attributes(fields_of_type(:attr))
    fetch_foreigns
    @obj
  end

  def build_obj
    case @klass.xls_mode
    when :create
      build_for_create_mode
    when :update
      build_for_update_mode
    end
  end

  def build_for_update_mode
    @klass.find_or_initialize_by(fields_of_type(:key))
  end

  def build_for_create_mode
    @klass.new
  end

  def fetch_foreigns
    fields_of_type(:f_key).each do |key, value|
      f_model, f_field = key.to_s.split '.'
      fetch_foreign_field(f_model, f_field, value)
    end
  end

  def fetch_foreign_field(f_model, f_field, value)
    f_class = Object.const_get f_model.classify
    f_obj = f_class.find_by!(f_field => value) unless value.blank?
    @obj.send("#{f_model}=", f_obj)
  rescue StandardError => e
    @obj.errors.add(:base, e.to_s)
  end

  def headers_of_type(type)
    @klass.xls_fields.select { |_k, v| v == type}
  end

  def fields_of_type(type)
    @row.select { |key, _v| headers_of_type(type).include? key }
  end

  def hts
    @hts ||= HeaderTranslatorService.new
  end
end
