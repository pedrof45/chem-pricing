class Quote < ApplicationRecord
  extend Enumerize

  belongs_to :user
  belongs_to :customer, required: false
  belongs_to :product
  belongs_to :dist_center
  belongs_to :city, required: false
  belongs_to :cost, required: false
  belongs_to :optimal_markup, required: false
  belongs_to :vehicle, required: false

  # TODO set quote_date

  after_validation :simulate!

  validates_presence_of :freight_condition, :quantity, :payment_term, :freight_base_type
  #, :freight_subtype PONER DENUEVO CUANDO FOB DESACTIVE LA CAJA DE FRETE
  validate :city_when_corresponds, :taxes_when_not_padrao,
           :corresponding_markup_price_input, :optimal_markup_format,
           :freight_fields_consistency, :quantity_format

  enumerize :freight_condition, in: [:cif, :fob, :redispatch]
  enumerize :unit, in: [:kg, :lt]
  enumerize :freight_base_type, in: [:bulk, :packed]


   def self.xls_mode
    :create
  end

  def self.xls_fields
    {
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
      freight_base_type: :attr,
      freight_subtype: :attr,
      'vehicle.name': :f_key,
      fixed_price: :attr,
      unit_price: :attr,
      markup: :attr
    }
  end

  def simulate!
    simulator_service = SimulatorService.new(q: self)
    freight_service = FreightService.new(q: self)
    simulator_service.setup_cost_and_markup
    unless errors.any?
      freight_service.run
    end
    unless errors.any? || unit_freight.nil?
      simulator_service.run
    end
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
    # TODO
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

  def optimal_markup_amount
    optimal_markup.value*100
  end

  def unit_freight_amount
    unit_freight.round(2)
  end

  def final_base_price
    (cost.base_price/cost.amount_for_price).round(2)
  end

  def unit_price_amount
    unit_price.round(2)
  end

  def calculated_markup_amount
    (markup/100)*final_base_price
  end

  def icms_amount

    (unit_price*icms).round(2)

  end

  def pis_confins_amount

    (unit_price*pis_confins).round(2)

  end

  def encargos
    return 0 if payment_term.zero?
    (unit_price*final_freight)
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

  def self.freight_subtype_options(type)
    if type.try(:to_sym) == :packed
      {
        chemical: 'Quimico',
        pharma: 'Farma',
        special: 'Frete Especial'
      }.invert
    elsif type.try(:to_sym) == :bulk
        basic_subtypes =
        {
            normal: 'Normal',
            #product: 'Produto'
        }
        chopped_subtypes = ChoppedBulkFreight.all.map do |cbf|
          ["chopped_#{cbf.id}".to_sym, cbf.operation]
      end.to_h
        basic_subtypes.merge(chopped_subtypes).invert
    end
  end

  def self.xls_mode
    :create
  end

  def self.xls_fields
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
#
# Indexes
#
#  index_quotes_on_city_id            (city_id)
#  index_quotes_on_cost_id            (cost_id)
#  index_quotes_on_customer_id        (customer_id)
#  index_quotes_on_dist_center_id     (dist_center_id)
#  index_quotes_on_optimal_markup_id  (optimal_markup_id)
#  index_quotes_on_product_id         (product_id)
#  index_quotes_on_user_id            (user_id)
#  index_quotes_on_vehicle_id         (vehicle_id)
#
# Foreign Keys
#
#  fk_rails_...  (customer_id => customers.id)
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (user_id => users.id)
#
