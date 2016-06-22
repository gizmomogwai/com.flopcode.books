class UserSession
  include ActiveModel::Model
  attr_accessor :account, :password

  def initialize(user=nil)
    @user = user
  end

  def self.authenticate(params)
    account = params[:account]
    password = params[:password]
    if Rails.configuration.x.authenticator.accept?(account, password)
      user = User.find_by_account(account)
      if user.nil?
        user = User.new(account: account, name: account, admin: false)
      end

      user.admin = Rails.configuration.x.authenticator.admin?(account, password)
      user.save!
      return UserSession.new(user)
    end
    return nil
  end
end
