user = User.new
user.email = 'sukhchander@selastik.com'
user.password = 'test2020'
user.admin! # set admin role
user.confirm
user.save

user = User.new
user.email = 'kellen@compose.io'
user.password = 'test2020'
user.admin! # set admin role
user.confirm
user.save
puts "\nCREATED ADMIN USER: " << user.email
puts "\nYOUR PASSWORD IS  : " << 'test2020'

# create users to mimic accounts
# user role defaults to user
# ideal design would be user has many accounts.
#                       accounts could be of various tiers: mini, micro, huge

puts "\nCREATING 200 USERS AS USER ACCOUNTS FOR ORDERS"

1.upto(200) do |i|
  user = User.new({email: FFaker::Internet.email, password: :changemeplease})
  user.confirm
  user.save
end

puts "\nCREATED 200 USERS AS USER ACCOUNTS FOR ORDERS"