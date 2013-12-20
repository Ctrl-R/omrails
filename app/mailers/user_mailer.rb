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
  
  def requestmembership(user, club)
    @adminid = club.admin
    @admin = User.find(@adminid)
    @user = user
    @club = club
    mail(:to => "#{@admin.name} <#{@admin.email}>", :from => @user.email, :reply_to => @user.email, :subject => "#{@user.name} has requested membership to #{@club.name}")
  end
  
  def membershipapproved(user, club)
    @adminid = club.admin
    @admin = User.find(@adminid)
    @user = user
    @club = club
    mail(:from => "#{@admin.name} <#{@admin.email}>", :to => @user.email, :reply_to => @admin.email, :subject => "#{@admin.name} has approved your membership to #{@club.name}")
  end
  
  def changeadminnotice(user, newadmin, club)
    @admin = newadmin
    @user = user
    @club = club
    mail(:from => "#{@user.name} <#{@user.email}>", :to => @admin.email, :reply_to => @user.email, :subject => "#{@user.name} has made you the administrator of #{@club.name}")
  end
  
  def report_club(user, club)
    @adminid = User.where(admin: TRUE)
    @admin = User.find(@adminid)
    @user = user
    @club = club
    mail(:to => "#{@admin.name} <#{@admin.email}>", :from => @user.email, :reply_to => @user.email, :subject => "#{@user.name} has reported #{@club.name} as abusive")
  end
  
end

#UserMailer.request_pin(current_user, @pin).deliver