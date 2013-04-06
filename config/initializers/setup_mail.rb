ActionMailer::Base.smtp_settings = {
  :address              => "camguyhotmailcom.dotster.com",
  :port                 => 587,
  :domain               => "ctrl-r.com",
  :user_name            => ENV["EMAIL_USERNAME"],
  :password             => ENV["EMAIL_PASSWORD"],
  :authentication       => "plain",
  :enable_starttls_auto => true,
  :openssl_verify_mode  => "none"
}

ActionMailer::Base.default_url_options[:host] = ENV["ACTIONMAILER_URL"]
#Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?