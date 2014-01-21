class ProviderUser < ActiveRecord::Base
  include Omniauth::MultipleProviders::AuthHashContainable
end

