class Quote < ApplicationRecord
  extend Enumerize

  belongs_to :user, required: false
  belongs_to :customer, required: false
  belongs_to :product
  belongs_to :dist_center
  belongs_to :city, required: false
  belongs_to :cost, required: false
  belongs_to :optimal_markup, required: false
  belongs_to :vehicle, required: false
  has_and_belongs_to_many :emails

  # TODO set quote_date (currently using created_at)

  before_create :set_current
  after_validation :simulate!

  validates_presence_of :freight_condition, :quantity, :payment_term
  #, :freight_base_type
  #, :freight_subtype PONER DENUEVO CUANDO FOB DESACTIVE LA CAJA DE FRETE
  validate :city_when_corresponds, :taxes_when_not_padrao,
           :corresponding_markup_price_input, :optimal_markup_format,
           :freight_fields_consistency, :quantity_format

  enumerize :freight_condition, in: [:cif, :fob, :redispatch]
  enumerize :unit, in: [:kg, :lt]
  enumerize :currency, in: [:brl, :usd, :eur]
  enumerize :freight_base_type, in: [:bulk, :packed]

  scope :watched_current, -> { where(watched: true, current: true) }


  def self.xls_mode
    :create
  end

  def self.xls_fields
    {
      'user.email': :f_key,
      'customer.code': :f_key,
      'product.sku': :f_key,
      'dist_center.code': :f_key,
      payment_term: :attr,
      quantity: :attr,
      icms_padrao: :attr,
      icms: :attr,
      pis_confins_padrao: :attr,
      pis_confins: :attr,
      ipi: :attr,
      brl_usd: :attr,
      brl_eur: :attr,
      freight_condition: :attr,
      'city.code': :f_key,
      freight_padrao: :attr,
      freight_base_type: :attr,
      freight_subtype: :attr,
      'vehicle.name': :f_key,
      fixed_price: :attr,
      unit_price: :attr,
      markup: :attr,
      'optimal_markup.table_value': :nil,
      'optimal_markup.value': :nil,
      'product.unit': :nil,
      'cost.currency': :nil,
      fob_net_price: :attr,
      unit_freight: :attr,
      watched: :attr,
      current: :attr
    }
  end

  def simulate!
    set_currencies
    simulator_service = SimulatorService.new(q: self)
    freight_service = FreightService.new(q: self) if freight_padrao
    simulator_service.setup_cost_and_markup
    if freight_padrao && errors.blank?
      freight_service.run
    end
    unless errors.any? || unit_freight.nil?
      simulator_service.run
    end
  end


  def set_current
    self.current = true if watched
  end

  def quantity_format
    errors.add(:quantity, "tem que ser maior a 0") if quantity.to_i <= 0
  end

  def optimal_markup_format
    # FIXME
    # if (markup<0 || markup>1)
    #   errors.add(:markup, "tem que ser maior a 1") if markup<0
    #   errors.add(:markup, "tem que ser menor a 1") if markup>1
    # end
  end

  def freight_fields_consistency
    if freight_padrao
      if freight_condition != 'fob'
        errors.add(:freight_base_type, "Obrigatório se 'Frete' foi selecionado") if freight_base_type.blank?
        errors.add(:freight_subtype, "Obrigatório se 'Frete' foi selecionado") if freight_subtype.blank?
      end
    elsif unit_freight.nil?
      errors.add(:unit_freight, 'Deve inserir un valor se não escolhe padrão')
    end
  end

  def city_when_corresponds
    if city.blank?
      errors.add(:city, "Obrigatório se 'Redespacho' foi selecionado") if freight_condition.redispatch?
      errors.add(:city, "Obrigatório se nenhum cliente foi selecionado") if customer.blank?
    end
  end

  def corresponding_markup_price_input
    errors.add(:unit_price, "Você deve digitar um valor se opçao 'Preço Unitario' foi selecionado") unless  unit_price.present? || !fixed_price
    errors.add(:markup, "Você deve digitar um valor se opçao 'Markup' foi selecionado") unless  markup.present? || fixed_price
  end

  def taxes_when_not_padrao
    errors.add(:icms, "Você deve digitar, ou selecionar 'padrão'") unless  icms.present? || icms_padrao
    errors.add(:pis_confins, "Você deve digitar, ou selecionar 'padrão'") unless  pis_confins.present? || pis_confins_padrao
  end

  def set_currencies
    self.brl_usd ||= GetExchangeRate.for(from: :USD, to: :BRL)
    self.brl_eur ||= GetExchangeRate.for(from: :EUR, to: :BRL)
  end

  def watched_current?
    watched && current
  end

  def origin_state
    dist_center.city.state if dist_center
  end

  def destination_state
    if customer.blank? || freight_condition.redispatch?
      city.try(:state)
    elsif customer
      customer.city.try(:state)
    end
  end

  def destination_itinerary
    if customer.blank? || freight_condition.redispatch?
      city.try(:code)
    elsif customer
      customer.city.try(:code)
    end
  end

  def last_sale
    if customer && product && dist_center
      product.sales.where(customer: customer, dist_center: dist_center).last
    elsif product && dist_center
      product.sales.where(dist_center: dist_center).last
    end
  end

  def total_price
    (unit_price * quantity).round(2).to_i
  end

  def fob_net_rounded
    fob_net_price.round(2)
  end

  def unit_freight_amount
    unit_freight.round(2)
  end

  def final_base_price
    (cost.base_price / cost.amount_for_price).round(2)
  end

  def unit_price_amount
    unit_price.round(2)
  end

  def calculated_markup_amount
      markup * final_base_price
  end

  def optimal_markup_amount
    optimal_markup.value.round(4) * 100 if optimal_markup.try(:value)
  end

  def mark_up_porcentage
    markup * 100 if markup
  end

  def icms_amount
    (unit_price * icms).round(2)
  end

  def pis_confins_amount
    (unit_price * pis_confins).round(2)
  end

  def financial_cost
    # TODO validate payment term range ( > 0? )
    # TODO Handle Sys Var Unset
    @financial_costs ||= begin
      if payment_term.try(:zero?)
        0
      else
        interest_sys_var = case payment_term
                             when (0..30)
                               :interest_2_30
                             when (31..60)
                               :interest_31_60
                             else
                               :interest_more_60
                           end
        interest = SystemVariable.get interest_sys_var
        ((interest + 1.0)**(payment_term/ 30.0)) -1.0
      end
    end
  end

  def encargos
    (unit_price * financial_cost)
  end

  def encargos_amount
    encargos.round(2)
  end

  def mcb
    (total_price - ((cost.base_price/cost.amount_for_price + (unit_price*icms) +(unit_price*pis_confins) + encargos+unit_freight)) * quantity).round(2).to_i
  end

  def quantity_lts
    return unless product && quantity
    product.unit.kg? ? quantity / product.density : quantity
  end

  def quantity_kgs
    return unless product && quantity
    product.unit.kg? ? quantity : quantity * product.density
  end

  def below_markup?
    opt_mkup = OptimalMarkup.where(product: product, dist_center: dist_center, customer: customer).last
    opt_mkup ||= OptimalMarkup.where(product: product, dist_center: dist_center, customer_id: nil).last
    return unless opt_mkup
    markup < opt_mkup.table_value
  end


  PACKED_SUBTYPES = {
        chemical: 'Quimico',
        pharma: 'Farma',
        special: 'Frete Especial'
    }

  BULK_BASIC_SUBTYPES =    {
      normal: 'Normal',
      #product: 'Produto'
    }

  def freight_subtype_text
    return unless freight_subtype.present?
    basic_subtypes = PACKED_SUBTYPES.merge(BULK_BASIC_SUBTYPES)
    if freight_subtype.in?(basic_subtypes.keys.to_s)
      basic_subtypes[freight_subtype]
    elsif freight_subtype.starts_with?('chopped_')
      ChoppedBulkFreight.find(freight_subtype.remove('chopped_')).operation
    else
      raise "Unhandled Freight Subtype: #{freight_subtype}"
    end
  end

  def self.freight_subtype_options(type = nil)
    return PACKED_SUBTYPES if type.try(:to_sym) == :packed
    bulk_chopped_subtypes = ChoppedBulkFreight.all.map do |cbf|
        ["chopped_#{cbf.id}".to_sym, cbf.operation]
    end.to_h
    bulk_subtypes = BULK_BASIC_SUBTYPES.merge(bulk_chopped_subtypes)
    return bulk_subtypes if type.try(:to_sym) == :bulk
    PACKED_SUBTYPES.merge(bulk_subtypes)
  end
end

# == Schema Information
#
# Table name: quotes
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  customer_id        :integer
#  product_id         :integer
#  quote_date         :datetime
#  icms_padrao        :boolean
#  icms               :decimal(, )
#  ipi                :decimal(, )
#  pis_confins_padrao :boolean
#  pis_confins        :decimal(, )
#  freight_condition  :string
#  brl_usd            :decimal(, )
#  brl_eur            :decimal(, )
#  quantity           :decimal(, )
#  unit               :string
#  unit_price         :decimal(, )
#  markup             :decimal(, )
#  fixed_price        :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  dist_center_id     :integer
#  city_id            :integer
#  optimal_markup_id  :integer
#  cost_id            :integer
#  fob_net_price      :decimal(, )
#  final_freight      :decimal(, )
#  comment            :string
#  unit_freight       :decimal(, )
#  payment_term       :integer
#  freight_base_type  :string
#  freight_subtype    :string
#  vehicle_id         :integer
#  upload_id          :integer
#  currency           :string
#  freight_padrao     :boolean
#  watched            :boolean
#  current            :boolean
#
# Indexes
#
#  index_quotes_on_city_id            (city_id)
#  index_quotes_on_cost_id            (cost_id)
#  index_quotes_on_customer_id        (customer_id)
#  index_quotes_on_dist_center_id     (dist_center_id)
#  index_quotes_on_optimal_markup_id  (optimal_markup_id)
#  index_quotes_on_product_id         (product_id)
#  index_quotes_on_upload_id          (upload_id)
#  index_quotes_on_user_id            (user_id)
#  index_quotes_on_vehicle_id         (vehicle_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
