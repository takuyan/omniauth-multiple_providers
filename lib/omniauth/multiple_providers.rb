require "omniauth/multiple_providers/version"
require "omniauth/multiple_providers/models/concerns/omniauthable"
require "omniauth/multiple_providers/models/concerns/auth_hash_containable"
require 'rails/engine'

module Omniauth
  module MultipleProviders
    class Engine < ::Rails::Engine
      isolate_namespace Omniauth::MultipleProviders
    end
  end
end
