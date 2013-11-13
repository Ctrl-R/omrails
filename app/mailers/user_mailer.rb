class UserMailer < ActionMailer::Base
  
  def request_pin(user, pin)
    @user = user
    @pin = pin
    mail(:to => "#{@pin.user.name} <#{@pin.user.email}>", :from => @user.email, :reply_to => @user.email, :subject => "#{@user.name} has requested #{@pin.description}")
  end
  
  def report_pin(user, pin)
    @adminid = User.where(admin: TRUE)
    @admin = User.find(@adminid)
    @user = user
    @pin = pin
    mail(:to => "#{@admin.name} <#{@admin.email}>", :from => @user.email, :reply_to => @user.email, :subject => "#{@user.name} has reported #{@pin.description} as abusive")
  end
  
end

#UserMailer.request_pin(current_user, @pin).deliver