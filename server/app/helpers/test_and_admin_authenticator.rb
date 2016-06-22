class TestAndAdminAuthenticator
  def accept?(username, password)
    return password == "test" || password == "admin"
  end
  def admin?(username, password)
    return password == "admin"
  end
end
