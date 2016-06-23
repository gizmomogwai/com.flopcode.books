require 'test_helper'

class ApiKeyActivatorMailerTest < ActionMailer::TestCase
  test "activate_api_key" do
    to = "christian.koestlin@gmail.com"
    u = User.new(name: "test", account: "test@mail.com", admin: false)
    u.save!
    email = ApiKeyActivatorMailer.api_key_activation(u, to, "1234").deliver_now
    assert_not ActionMailer::Base.deliveries.empty?
    assert_equal ['buecherwurm@esrlabs.com'], email.from
    assert_equal [to], email.to
    assert_equal 'Activate Buecherwurm API Key', email.subject
 #   assert_equal read_fixture('invite').join, email.body.to_s
  end
end
