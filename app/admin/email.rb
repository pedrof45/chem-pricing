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
      span link_to 'Volver', emails_path, id: 'email-show-back-button'
    end
    div id: 'email-preview-container' do
      render file: 'quotes_mailer/quotes_mail.html.erb'
    end
  end

  controller do
    def build_new_resource
      if params[:email] # when validation fails
        params[:email][:quotes] = params[:email][:quotes]&.split(',')
        params[:email][:message] = params[:email][:message]&.gsub("\r\n", '<br>')
      end
      em = super
      em.user = current_user
      em.customer ||= Customer.find_by(id: params[:customer_id])
      quote_ids = params[:quote_ids] || params[:email].try(:[], :quotes)
      em.quotes = if current_user.manager_or_more?
                    Quote.where(id: quote_ids)# if em.quotes.blank?
                  else
                    current_user.quotes.where(id: quote_ids)
                  end
      em.subject ||= "Tabela de preços quantiQ - #{em.customer&.name}"
      current_month_name_br = I18n.t("date.month_names")[Time.current.month]&.downcase
      em.message ||= "Prezado cliente,\nSegue abaixo as cotações para o mês de #{current_month_name_br}.\nTodos os itens estão sujeitos à disponibilidade de estoque."
      em
    end
  end
end
