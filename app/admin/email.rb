ActiveAdmin.register Email do
  menu parent: '6. Companhia'
  permit_params :customer_id, :recipient, :subject, :message, :quotes

  actions :index, :new, :create, :show

  index do
    column :user if current_user.manager_or_more?
    column :customer
    column :recipient
    column :subject
    column :message
    column('Cotações') do |email|
      quotes_count = email.quotes.count
      link_to "#{quotes_count} #{'Fila'.pluralize(quotes_count)}", quotes_path(q: { id_in: email.quotes.map(&:id) }, scope: 'todas'),  target: '_blank'
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
      input :message, as: :text, input_html: { rows:  7}
    end
    f.actions

    h3 'Previsualização:'
    div style: 'all: initial;font-family: Arial, Helvetica, sans-serif;' do
      render file: 'quotes_mailer/quotes_mail.html.erb'
    end
  end

  show do
    span do
      h3 'Previsualização:', style: 'float: left;'
      button 'Volver', onclick: "history.back();", id: 'email-show-back-button'
    end
    div id: 'email-preview-container' do
      render file: 'quotes_mailer/quotes_mail.html.erb'
    end
  end

  controller do
    def build_new_resource
      params[:email][:quotes] = params[:email][:quotes]&.split(',') if params[:email]
      em = super
      em.user = current_user
      em.customer ||= Customer.find_by(id: params[:customer_id])
      quote_ids = params[:quote_ids] || params[:email].try(:[], :quotes)
      em.quotes = Quote.where(id: quote_ids)# if em.quotes.blank?
      em
    end
  end
end
