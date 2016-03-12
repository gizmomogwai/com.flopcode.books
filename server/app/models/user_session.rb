class UserSession
  include ActiveModel::Model
  attr_accessor :account, :password

  def initialize(user=nil)
    @user = user
  end

  def self.authenticate(params)
    puts params
    account = params[:account]
    password = params[:password]
    user = User.find_by_account(account)
    if user.nil? then
      return nil
    elsif password == "test" then
      return UserSession.new(user)
    else
      return nil
    end
  end
end
