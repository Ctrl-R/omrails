class UserMailer < ActionMailer::Base
  default :from => "ian@ctrl-r.com"
  
  def request_pin(user, pin)
    @user = user
    @pin = pin
    mail(:to => "#{@pin.user.name} <#{@pin.user.email}>", :reply_to => @user.email, :subject => "#{@user.name} has requested #{@pin.description}")
  end
  
end

#UserMailer.request_pin(current_user, @pin).deliver