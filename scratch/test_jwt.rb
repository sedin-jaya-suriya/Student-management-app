require_relative '../config/environment'
include Rack::Test::Methods

def app
  Rails.application
end

# 1. Login to get a token
puts "Attempting login..."
post '/api/login', { user: { email: 'teacher@gmail.com', password: 'password' } }.to_json, { 'CONTENT_TYPE' => 'application/json', 'HTTP_ACCEPT' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }

puts "Status: #{last_response.status}"
puts "Headers: #{last_response.headers.inspect}"
puts "Body: #{last_response.body}"

if last_response.status == 200
  body = JSON.parse(last_response.body)
  token = body['token']
  puts "Extracted Token: #{token}"

  # 2. Access a protected endpoint /api/teachers
  puts "\nAccessing /api/teachers with token..."
  header 'Authorization', "Bearer #{token}"
  get '/api/teachers', {}, { 'HTTP_ACCEPT' => 'application/json', 'HTTP_HOST' => '127.0.0.1' }
  puts "Status: #{last_response.status}"
  puts "Headers: #{last_response.headers.inspect}"
  puts "Body: #{last_response.body}"
else
  puts "Login failed!"
end
