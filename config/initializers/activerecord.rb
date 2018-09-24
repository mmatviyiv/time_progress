db_url = ENV['DATABASE_URL']

unless db_url.nil?
  parsed = URI.parse(db_url)
  config = {
      adapter:  parsed.scheme,
      username: parsed.user,
      password: parsed.password,
      port:     parsed.port,
      database: parsed.path.sub(%r{^/}, ''),
      host:     parsed.host
  }
  config.reject!{|key, value| value.nil?}

  ActiveRecord::Base.establish_connection(config)
end
