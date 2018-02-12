class QuoteMailer < ApplicationMailer

  # DEPRECATED
  def send_email(email)
    @email = email
    mail(from: email.user.email, to: email.recipient, subject: email.subject) do |format|
      format.html { render 'quotes_mailer/quotes_mail' }
    end
  end

  def send_with_sendgrid(email)
    @email = email
    set_subject(email.subject)
    set_content(render('quotes_mailer/quotes_mail'), 'text/html')
    set_sender(email.user.name_and_email)
    set_recipients(:to, email.recipient.to_s.split(','))
    set_recipients(:bcc, email.user.email)
    mail
  end
end
