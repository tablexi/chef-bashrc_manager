source 'https://rubygems.org'

ruby '2.4.1'

gem 'berkshelf'
gem 'chef', '~> 12'

group :ci do
  gem 'bump'
  gem 'github_changelog_generator'
end

group :dev do
  gem 'chefspec'
  gem 'foodcritic'
  gem 'rubocop'
  gem 'stove'
end

group :guard do
  gem 'guard'
  gem 'guard-foodcritic'
  gem 'guard-kitchen'
  gem 'guard-rspec'
  gem 'guard-rubocop'
  gem 'ruby_gntp'
end

group :kitchen do
  gem 'chef-zero'
  gem 'kitchen-docker'
  gem 'kitchen-ec2'
  gem 'kitchen-transport-rsync'
  gem 'test-kitchen'
end
