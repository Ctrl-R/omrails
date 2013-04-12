class UserMailer < ActionMailer::Base
  
  def request_pin(user, pin)
    @user = user
    @pin = pin
    mail(:to => "#{@pin.user.name} <#{@pin.user.email}>", :from => @user.email, :reply_to => @user.email, :subject => "#{@user.name} has requested #{@pin.description}")
  end
  
end

#UserMailer.request_pin(current_user, @pin).deliver