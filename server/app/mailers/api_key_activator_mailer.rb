class ApiKeyActivatorMailer < ApplicationMailer
  def api_key_activation(user, email, api_key_activation)
    @user = user
    @email = email
    @api_key_activation_url = user_api_key_activate_url(user, api_key_activation)
    puts @api_key_activation_url
    mail(to: email, subject: 'Activate Buecherwurm API Key')
  end
end
