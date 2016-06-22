require 'net/ldap'
class LdapAuthenticator
  def ldap(account, password)
    return Net::LDAP.new(host: "dc02.esrlabs.local",
                         port: 389,
                         auth: {
                           method: :simple,
                           username: "#{account}@esrlabs.local",
                           password: password
                         })
  end

  def accept?(account, password)
    puts "LdapAuthenticator.accept?"
    return ldap(account, password).bind
  end

  def admin?(account, password)
    puts "LdapAuthenticator.admin?"

    ldap_connection = ldap(account, password)
    ok = ldap_connection.bind
    return false unless ok

    treebase = "dc=esrlabs,dc=local"
    filter = "(&(objectClass=user)(sAMAccountName=christian.koestlin)(memberof=cn=BooksAdmin,cn=users,dc=esrlabs,dc=local))"
    return ldap_connection.search(base: treebase, filter: filter).first != nil
  end
end
