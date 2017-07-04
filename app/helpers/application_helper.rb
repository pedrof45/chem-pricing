module ApplicationHelper
  def login_flash_messages
    flash_messages.reject do |_key, value|
      value == "You need to sign in or sign up before continuing."
    end
  end

  def build_csv_columns(model)
    klass = Object.const_get model.to_s.classify
    hts = HeaderTranslatorService.new

    columns = klass.xls_fields.map do |field, _v|
      label = hts.field_to_pt(model, field)

      if field.to_s.include? '.'
        f_model, f_field = field.to_s.split '.'
        proc = Proc.new { |r| r.send(f_model).try(f_field)  }
      else
        proc = Proc.new { |r| r.send(field) }
      end
      [label, proc]
    end.to_h
  end
end
