require 'active_support/concern'

module Omniauth
  module MultipleProviders
    module Omniauthable
      extend ActiveSupport::Concern

      included do
        has_many :provider_users, dependent: :destroy
      end

      def create_or_update_provider_user_by(auth)
        if provider_user = self.provider_users.find_by(uid: auth['uid'], provider: auth['provider'])
          provider_user.update_by(auth)
        else
          provider_user = self.provider_users.build
          provider_user.update_by(auth)
        end
      end

      def oauthed?(provider_name)
        if up = self.provider_users.find_by(provider: provider_name)
          up
        else
          nil
        end
      end

      module ClassMethods
        def find_or_create_by_oauth(auth, current_user)
          @user = if current_user
            current_user.create_or_update_provider_user_by(auth)
            current_user
          else
            if user = User.find_by_oauth(auth)
              user.create_or_update_provider_user_by(auth)
              user
            else
              user = User.create_by_oauth(auth)
              user.save
              user.create_or_update_provider_user_by(auth)
              user
            end
          end
        end

        def find_by_oauth(auth)
          if up = ProviderUser.find_by(uid: auth['uid'], provider: auth['provider'])
            up.user
          else
            nil
          end
        end

        def create_by_oauth(auth)
          logger.debug "##### Auth Hash: #{auth.to_json}"
          case auth['provider']
          when 'twitter'
            # Twitter not give me email from api
            User.create_by_twitter(auth)
          when 'facebook', 'google_oauth2', 'github'
            # Other api give me email
            User.create_by_omniauth(auth)
          else
            User.new
          end
        end

        def create_by_omniauth(auth)
          u = User.new
          u.email = auth['info']['email']
          u.name = auth['info']['name']
          password = Devise.friendly_token[0,20]
          u.password = password
          u.password_confirmation = password
          u.skip_confirmation! # Because we get confirmed (by providers) email !
          u.save
          u
        end

        def create_by_twitter(auth)
          # https://github.com/arunagw/omniauth-twitter#authentication-hash
          u = User.new
          # u.email = auth['info']['email'] # Twitter not give me email from api
          u.name = auth['info']['name']
          password = Devise.friendly_token[0,20]
          u.password = password
          u.password_confirmation = password
          u.save
          u
        end
      end
    end
  end
end
