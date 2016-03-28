def seed_test_db
  locations = Location.create([
                                {name: 'l-one', description: 'desc 1'},
                                {name: 'l-two', description: 'desc 2'}
                              ])
  users = User.create([
                        {name: 'name1', account: 'account1', admin: true},
                        {name: 'name2', account: 'account2', admin: false}
                      ])
  books = Book.create([
                        {isbn: 'isbn1', title: 'title1', authors: 'authors1', user: users[0], location: locations[0]},
                        {isbn: 'isbn2', title: 'title2', authors: 'authors2', user: users[1], location: locations[1]}
                      ])
  api_keys = ApiKey.create([
                             {key: 'key1', for_app: 'app1', user: users[0]},
                             {key: 'key2', for_app: 'app2', user: users[1]}
                           ])
end

case Rails.env
when 'test'
  seed_test_db
else
end
