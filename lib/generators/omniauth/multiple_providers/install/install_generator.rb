require 'rails/generators'

module Omniauth
  module MultipleProviders
    module Generators
      class InstallGenerator < ::Rails::Generators::Base
        source_root File.expand_path("../templates", __FILE__)

        def add_provider_user
          copy_file 'provider_user.rb', 'app/models/provider_user.rb'
        end

        def create_provider_user
          # FIXME add datetime require
          copy_file 'create_provider_users.rb', "db/migrate/#{DateTime.now.strftime('%Y%m%d%H%M%S')}_create_provider_users.rb"
        end

        def insert_to_user
          #insert_into_file 'app/models/user.rb', '  include Omniauth::MultipleProviders::Omniauthable', after: 'class User < ActiveRecord::Base'
          inject_into_class 'app/models/user.rb', User do
            "  include Omniauth::MultipleProviders::Omniauthable\n"
          end
        end

        def add_multiple_providers_routes
          route "get '/auth/:provider/callback' => 'omniauth/multiple_providers#create'"
          route "get '/auth/failure' => 'omniauth/multiple_providers#failure'"
          route "resources :omniauth, only: [:new, :create, :failure, :destroy], controller: 'omniauth/multiple_providers'"
        end
      end
    end
  end
end

