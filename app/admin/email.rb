ActiveAdmin.register Email do
  menu parent: '6. Companhia'
  permit_params :customer_id, :recipient, :subject, :message, :quotes

  actions :all, except: [:show, :destroy, :edit, :update]

  index do
    column :user if current_user.manager_or_more?
    column :customer
    column :recipient
    column :subject
    column :message
    column('Cotações') do |email|
      quotes_count = email.quotes.count
      "#{quotes_count} #{'Cotações'.pluralize(quotes_count)}"
    end
    column :created_at
    actions
  end

  form do |f|
    inputs do
      input :customer, collection: [resource.customer], input_html: { class: "default-select", readonly: true, style: 'font-size: 14px;'  }
      input :quotes, as: :tags, input_html: { value: resource.quotes&.map(&:id)&.join(','), readonly: true }
      input :recipient, as: :tags, collection: resource.customer&.contacts&.map(&:name_and_email)
      input :subject
      input :message, as: :string, input_html: { rows: 5 }
    end
    f.actions

    h3 'Previsualização:'
    div style: 'all: initial;font-family: Arial, Helvetica, sans-serif;' do
      render file: 'quotes_mailer/quotes_mail.html.erb'
    end
  end

  # show do
  #   attributes_table do
  #     row :customer
  #     row :recipient
  #     row :subject
  #     row :message
  #   end
  # end

  controller do
    def build_new_resource
      params[:email][:quotes] = params[:email][:quotes]&.split(',') if params[:email]
      em = super
      em.user = current_user
      em.customer ||= Customer.find_by(id: params[:customer_id])
      quote_ids = params[:quote_ids] || params[:email].try(:[], :quotes)
      em.quotes = Quote.where(id: quote_ids)# if em.quotes.blank?
      #em.quote_ids = params[:quote_ids]
      em
    end

    # def create
    #
    #   super do |w|
    #     binding.pry
    #   end
    # end
  end

end
