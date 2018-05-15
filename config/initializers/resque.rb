# Establish a connection between Resque and Redis
if Rails.env == "production"
  uri = URI.parse ENV["REDIS_URL"]
  Resque.redis = Redis.new host:uri.host, port:uri.port, password:uri.password
else
  # conf for your localhost
end
