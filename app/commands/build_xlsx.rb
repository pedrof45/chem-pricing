class BuildXlsx < PowerTypes::Command.new(:quotes)

  def perform
    preload_associations
    add_headers_row
    set_styles
    @quotes.each_with_index { |q, i| build_row(q, i + 1) }
    book.save(file_path)
    file_path
  end

  def preload_associations
    if @quotes.is_a?(Array)
      @quotes = Quote.where(id: @quotes.map(&:id))
    end
    @quotes = @quotes.preload(:user, :customer, :dist_center, :product, :cost, :optimal_markup, :vehicle, :city)
  end

  def fields
    {
      user_email: "Email - Usuario",
      customer_code: "Codigo Cliente",
      customer_name: "Nome Cliente",
      dist_center_code: "Codigo - CD",
      product_sku: "SKU - Produto",
      product_name: "Nome Produto",
      packaging: "Embalagem",
      cost_currency: "Moeda - Preco Piso",
      product_unit: "Unidade - Produto",
      cost_value: "Preço Piso",
      cost_suggested_markup: "Política",
      markup_value: "MarkUp Meta - Politica de MarkUp",
      markup_table_value: "MarkUp Tabela - Politica de MarkUp",
      quote_markup: "MarkUp Calculado (%)",
      quote_fob_net_price: "Preco Fob Net ($/UN)", # formula
      quote: "Cotação",
      product_density: "Densidade",
      quote_unit_price: "Preco Unitario ($)",
      quote_currency_unit: "Moeda/Unidade",
      quote_last_month_price: "PREÇO Mês Anterior",
      quote_last_month_delta: "Varia. Mês%",
      quote_freight_conditions: "Condicoes de Frete",
      quote_unit_freight: "Frete ($/UN)",
      quote_icms: "ICMS",
      quote_pis_confins: "Pis/Confins",
      quote_ipi: "IPI",
      quote_payment_term: "Prazo de Pagamento (dias)",
      quote_encargos: "ENCARGO",
      quote_observation: "Observação",
      quote_current: "Custo atual.",
      quote_city: "Itinerario - Municipio",
      quote_freight_type: "Tipo", # include subtype
      quote_vehicle: "Nome - Veiculo",
      customer_city: "Cidade/Estado do Cliente (Itinerario - Municipio)"
    }
  end

  def column_widths
    {
      user_email: 125,
      customer_code: 87,
      customer_name: 73,
      dist_center_code: 65,
      product_sku: 87,
      product_name: 90,
      packaging: 65,
      cost_currency: 65,
      product_unit: 65,
      cost_value: 65,
      cost_suggested_markup: 65,
      markup_value: 80,
      markup_table_value: 80,
      quote_markup: 80,
      quote_fob_net_price: 80,
      quote: 65,
      product_density: 65,
      quote_unit_price: 85,
      quote_currency_unit: 65,
      quote_last_month_price: 65,
      quote_last_month_delta: 65,
      quote_freight_conditions: 65,
      quote_unit_freight: 65,
      quote_icms: 65,
      quote_pis_confins: 65,
      quote_ipi: 65,
      quote_payment_term: 65,
      quote_encargos: 65,
      quote_observation: 65,
      quote_current: 65,
      quote_city: 65,
      quote_freight_type: 110,
      quote_vehicle: 90,
      customer_city: 150
    }
  end

  def add_headers_row
    fields.values.each_with_index do |pt_name, col|
      sheet.add_cell(0, col, pt_name)
    end
  end

  def build_row(q, row_index)
    fields.keys.each_with_index do |field, col_index|
      value = send("#{field}_column", q, row_index + 1)
      if value.is_a?(Array) # has format
        sheet.add_cell(row_index, col_index, value.first)
        sheet[row_index][col_index].set_number_format value.last
      elsif value.is_a?(Hash) # is a formula
        formula = value[:formula]
        format = value[:format]
        sheet.add_cell(row_index, col_index, '', formula)
        sheet[row_index][col_index].set_number_format format if format
      else
        sheet.add_cell(row_index, col_index, value)
      end
    end
  end

  BLUE_HEADER_INDEXES = [14, 17, 18, 27]

  def set_styles
    sheet.change_row_height(0, 30)
    fields.count.times do |col_i|
      fill_color = col_i.in?(BLUE_HEADER_INDEXES) ? '0073BB' : 'E6005B'
      sheet.sheet_data[0][col_i].change_fill(fill_color)
      sheet.sheet_data[0][col_i].change_font_bold(true)
      sheet.sheet_data[0][col_i].change_font_color('FFFFFF')
      sheet.change_row_vertical_alignment(0, 'center')
      sheet.sheet_data[0][col_i].change_border(:bottom, 'thin')
      sheet.sheet_data[0][col_i].change_border(:right, 'thin')
    end

    pixels_per_cm = 6.0 # value must be given in cm
    column_widths.values.each_with_index do |width, col_index|
      sheet.change_column_width(col_index, width / pixels_per_cm)
    end
  end

  def book
    @book ||= RubyXL::Workbook.new
  end

  def sheet
    @sheet ||= book[0]
  end

  def file_path
    @file_path ||= begin
      timestamp = Time.current.to_json.gsub(':','-')[1..19]
      "#{Rails.root}/tmp/cotacoes-#{timestamp}.xlsx"
    end
  end

  # number transformation methods
  def to_money(num)
    [num, '$###,###.00']
  end

  def to_percentage(num)
    [num, '0%']
  end

  # columns values methods

  def user_email_column(q, _row_num)
    q.user.email
  end

  def customer_code_column(q, _row_num)
    q.customer.code
  end

  def customer_name_column(q, _row_num)
    q.customer.name
  end

  def dist_center_code_column(q, _row_num)
    q.dist_center.code
  end

  def product_sku_column(q, _row_num)
    q.product.sku
  end

  def product_name_column(q, _row_num)
    q.product.name
  end

  def packaging_column(q, _row_num)
    p_code = q.product.packaging_code
    packaging_hash[p_code.to_i]
  end

  def cost_currency_column(q, _row_num)
    q.cost.currency_text
  end

  def product_unit_column(q, _row_num)
    q.product.unit_text
  end

  def cost_value_column(q, _row_num)
    to_money q.cost.base_price
  end

  def cost_suggested_markup_column(q, _row_num)
    to_percentage q.cost.suggested_markup
  end

  def markup_value_column(q, _row_num)
    to_percentage q.optimal_markup&.value
  end

  def markup_table_value_column(q, _row_num)
    to_percentage q.optimal_markup&.table_value
  end

  def quote_markup_column(q, _row_num)
    to_percentage q.markup
  end

  def quote_fob_net_price_column(_q, row_num)
    {
      formula: "IFERROR((J#{row_num}*(1+N#{row_num})),\"-\")",
      format: '$###,###.00'
    }
  end

  def quote_column(q, _row_num)
    # TODO ???
  end

  def product_density_column(q, _row_num)
    q.product.density.round(4)
  end

  def quote_unit_price_column(_q, row_num)
    {
      formula:
        "=((O#{row_num}+W#{row_num})/(1-X#{row_num}-Y#{row_num}))*(1+AB#{row_num})",
      format: '$###,###.00'
    }
  end

  def quote_currency_unit_column(_q, row_num)
    r = row_num
    {
      formula:
      (
  "=IF(AND(P#{r}=\"\",Q#{r}=\"\"),H#{r}&\"/\"&I#{r},IF(AND(P#{r}<>\"\",Q#{r}=\"\"),\"BRL\"&\"/\"&I#{r}," +
  "IF(AND(P#{r}=\"\",Q#{r}<>\"\"),H#{r}&\"/\"&(IF(I#{r}=\"kg\",\"lt\",\"kg\")),\"BRL\"&\"/\"&(IF(I#{r}=\"kg\",\"lt\",\"kg\")))))"
      )
    }
  end

  def quote_last_month_price_column(q, _row_num)
    nil # leave blank!
  end

  def quote_last_month_delta_column(q, _row_num)
    nil # leave blank!
  end

  def quote_freight_conditions_column(q, _row_num)
    q.freight_condition_text
  end

  def quote_unit_freight_column(q, _row_num)
    to_money q.unit_freight
  end

  def quote_icms_column(q, _row_num)
    to_percentage q.icms
  end

  def quote_pis_confins_column(q, _row_num)
    to_percentage q.pis_confins
  end

  def quote_ipi_column(q, _row_num)
    q.ipi
  end

  def quote_payment_term_column(q, _row_num)
    q.payment_term
  end

  def quote_encargos_column(_q, row_num)
    r = row_num
    {
      formula:
    "=IF(AA#{r}=\"\",\"-\",IFERROR((1+IF(AA#{r}<=30,2%,IF(AA#{r}<=60,2.5%,3.5%)))^(AA#{r}/30)-1,0))",
      format: '0%'
    }
  end

  def quote_observation_column(q, _row_num)
    nil # leave blank!
  end

  def quote_current_column(q, _row_num)
    if q.watched
      q.current
    else
      'Não Monitorada'
    end
  end

  def quote_city_column(q, _row_num)
    q.destination_city_full_name
  end

  def quote_freight_type_column(q, _row_num)
    [q.freight_base_type_text.to_s, q.freight_subtype_text.to_s].join(' - ')
  end

  def quote_vehicle_column(q, _row_num)
    q.vehicle&.name
  end

  def customer_city_column(q, _row_num)
    q.customer&.city&.name
  end

  # query helpers

  def packaging_hash
    @packaging_hash ||= Packaging.pluck(:code, :name).to_h
  end
end