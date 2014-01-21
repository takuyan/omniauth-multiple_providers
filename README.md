# Omniauth::MultipleProviders

Good parts for Omniauth and Multiple Providers.

## Installation

Add this line to your application's Gemfile:

    gem 'omniauth'
    gem 'omniauth-facebook' # etc you needs
    gem 'omniauth-twitter'  # etc you needs
    # ...
    gem 'omniauth-multiple_providers'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install omniauth-multiple_providers

## Usage

    $ rails generate omniauth:multiple_providers:install
    $ rake db:migrate # => create provider_users table

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
