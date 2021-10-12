source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.1'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jbuilder', '~> 2.5'
gem 'devise', '~> 4.5'
gem 'slack-ruby-client', '~> 0.13.0'
gem 'redis', '~> 4.0.2'
gem 'resque-scheduler', '~> 4.3.1'
gem 'tzinfo-data', '~> 1.2018.5'

group :development, :test do
  gem 'sqlite3', '~> 1.3.13'
end

group :production do
  gem 'pg', '~> 1.1.3'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end
