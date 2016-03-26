class UserSession
  include ActiveModel::Model
  attr_accessor :account, :password

  def initialize(user=nil)
    @user = user
  end

  def self.authenticate(params)
    puts "xxxxxxxxx #{params}"
    account = params[:account]
    password = params[:password]
    user = User.find_by_account(account)
    if user.nil?
      return nil
    elsif password == "test" then
      return UserSession.new(user)
    else
      return nil
    end
  end
end
