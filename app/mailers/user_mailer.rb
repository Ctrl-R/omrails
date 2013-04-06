class UserMailer < ActionMailer::Base
  default :from => "ian@ctrl-r.com"
  
  def request_pin(user, pin)
    @user = current_user
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Registered at Columbia Yak Attack Gear Swap")
  end
end