class NotificationMailer < ApplicationMailer
  add_template_helper(ApplicationHelper)


  def send_with_sendgrid(type, objects, recipients)
    @objects = objects
    set_subject("[QPRICING] Notificação de mudanças em #{pretty_type(type)}")
    set_content(render('notification_mailer/notifications_mail'), 'text/html')
    set_sender("QPricing <noreply@quantiq.com.br>")
    set_recipients(:to, recipients.map(&:email))
    mail
  end

  def pretty_type(type)
    case type.to_s
      when 'costs'
        'Preços Piso'
      when 'general'
        'Fretes'
      when 'sysadmins'
        'Sysadmins (todas as tabelas)'
      else
        raise "Unhandled notification type #{type}"
    end
  end
end
