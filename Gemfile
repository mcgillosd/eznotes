source 'https://rubygems.org'

ruby '2.0.0'
#ruby-gemset=EZNotes_rails_4_0

gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0'
gem 'bcrypt-ruby',	'~> 3.0.0'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

gem 'rails_12factor', group: :production

# gem for authentication to ldap server
gem 'net-ldap', '0.3.1'

# Gem Postgres in order to work with heroku
# We will be using postgres in development testing and deployment
gem 'pg', '0.15.1'

# Gem to handle file attachments
gem 'paperclip', '~> 3.0'

# annotate database models
gem 'annotate', ">=2.5.0"

# gems used only in development and testing
group :development, :test do
	gem 'rspec-rails', '2.13.2'
	gem 'guard-rspec', '2.5.0'
	gem 'spork-rails', github: 'sporkrb/spork-rails'
	gem 'guard-spork', '1.5.1'
	gem 'childprocess', '0.3.9'
	gem 'better_errors'
	gem 'binding_of_caller'
	gem 'meta_request'
end

group :development do
	gem 'rails-erd'
end


gem 'sass-rails',   	'4.0.0'
gem 'uglifier', 		'2.1.1'
gem 'coffee-rails', 	'4.0.0'
gem 'jquery-rails', 	'2.2.1'
gem 'jquery-ui-rails'
gem 'turbolinks',		'1.1.1'
gem 'jbuilder',		'1.0.2'

group :doc do
	gem 'sdoc',	'0.3.20', require: false
end

group :test do
	gem 'selenium-webdriver',	'~>2.35.1'
	gem 'capybara', 			'2.1.0'
	gem 'factory_girl_rails',	'4.2.1'
	gem 'shoulda-matchers'
end
