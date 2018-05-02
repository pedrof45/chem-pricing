class HeaderTranslatorService < PowerTypes::Service.new

  def model_fields_to_pt(model)
    klass = class_from(model)
    klass.xls_fields.map { |k, _v| [k, field_to_pt(model, k) ] }.to_h
    # Now all classes respond to xls_fields
    # if klass.respond_to?(:xls_fields)
    #   klass.xls_fields.map { |k, _v| [k, field_to_pt(model, k) ] }.to_h
    # else
    #   klass.attribute_names.map { |attr| [attr, field_to_pt(model, attr) ] }.to_h
    # end
  end

  def model_fields_xls_hash_to_pt(model)
    translations = model_fields_to_pt(model)
    klass = class_from(model)
    klass.xls_fields.map { |k, v| [translations[k], v] }.to_h
  end

  def field_to_en(en_model, pt_field)
    pt_field_tr = I18n.transliterate(pt_field)
    return foreign_field_to_en(pt_field_tr) if pt_field_tr.to_s.include?(' - ')
    translations = model_fields_to_pt(en_model).invert
    translations[pt_field_tr]
  end

  def field_to_pt(model, field)
    return foreign_field_to_pt(field) if field.to_s.include?('.')
    tr = I18n.t("activerecord.attributes.#{model}.#{field}")
    I18n.transliterate(tr)
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
    tr = "#{field_pt} - #{model_pt}"
    I18n.transliterate(tr)
  end

  def class_from(model_name)
    Object.const_get model_name.to_s.classify
  end

  def model_name_from_pt(pt_model)
    pt_model_tr = I18n.transliterate(pt_model)
    ApplicationRecord.descendants.map { |k| k.name.underscore }.find do |model_name|
      I18n.transliterate(I18n.t("activerecord.models.#{model_name}.one")) == pt_model_tr
    end
  end

  def enum_field_to_pt(model, field, value)
    I18n.t("enumerize.#{model}.#{field}.#{value}") if value.present?
  end

  def enum_field_to_en(model, field, pt_value)
    enum_tr_hash(model, field)[pt_value]
  end

  def enum_tr_hash(model, field)
    klass = class_from(model)
    @enum_translations ||= Hash.new({})
    @enum_translations[model][field] ||= klass.send(field).values.map do |value|
      [value, enum_field_to_pt(model, field, value)]
    end.to_h.invert
  end
end
