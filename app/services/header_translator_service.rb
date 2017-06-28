class HeaderTranslatorService < PowerTypes::Service.new

  def model_fields_to_pt(model)
    klass = class_from(model)
    if klass.respond_to?(:xls_fields)
      klass.xls_fields.map { |k, _v| [k, field_to_pt(model, k) ] }.to_h
    else
      klass.attribute_names.map { |attr| [attr, field_to_pt(model, attr) ] }.to_h
    end
  end

  def model_fields_xls_hash_to_pt(model)
    translations = model_fields_to_pt(model)
    klass = class_from(model)
    klass.xls_fields.map { |k, v| [translations[k], v] }.to_h
  end

  def field_to_en(en_model, pt_field)
    return foreign_field_to_en(pt_field) if pt_field.to_s.include?(' - ')
    translations = model_fields_to_pt(en_model).invert
    translations[pt_field]
  end

  def field_to_pt(model, field)
    return foreign_field_to_pt(field) if field.to_s.include?('.')
    I18n.t("activerecord.attributes.#{model}.#{field}")
  end

  def foreign_field_to_en(pt_field)
    pt_field, pt_model = pt_field.split(' - ')
    en_model = model_name_from_pt(pt_model)
    en_field = field_to_en(en_model, pt_field)
    "#{en_model}.#{en_field}".to_sym
  end

  def foreign_field_to_pt(field)
    f_model, f_field = field.to_s.split '.'
    field_pt = I18n.t("activerecord.attributes.#{f_model}.#{f_field}")
    model_pt = I18n.t("activerecord.models.#{f_model}.one")
    "#{field_pt} - #{model_pt}"
  end

  def class_from(model_name)
    Object.const_get model_name.to_s.classify
  end

  def model_name_from_pt(pt_model)
    ApplicationRecord.descendants.map { |k| k.name.underscore }.find do |model_name|
      I18n.t("activerecord.models.#{model_name}.one") == pt_model
    end
  end
end
