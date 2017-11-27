class QuoteMailer < ApplicationMailer

  def send_email(email)
    @email = email
    mail(to: email.recipient, subject: email.subject) do |format|
      format.html { render 'quotes_mailer/quotes_mail' }
    end
  end
end
