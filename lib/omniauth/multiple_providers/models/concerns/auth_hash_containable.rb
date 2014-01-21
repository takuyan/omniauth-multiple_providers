require 'active_support/concern'

module Omniauth
  module MultipleProviders
    #
    # # Usage
    # class ProviderUser < ActiveRecord::Base
    #   include Omniauth::MultipleProviders::AuthHashContainable
    # end
    module AuthHashContainable
      extend ActiveSupport::Concern

      included do
        belongs_to :user
        validates_presence_of :user_id, :provider, :uid
        validates_uniqueness_of :provider, scope: :user_id
        validates_uniqueness_of :uid, scope: :provider
      end

      # TODO use method_missing
      def update_by(auth)
        self.provider = auth['provider']
        self.uid = auth['uid']
        case auth['provider']
        when 'twitter'
          update_by_twitter(auth)
        when 'facebook'
          update_by_facebook(auth)
        when 'github'
          update_by_github(auth)
        when 'google_oauth2'
          update_by_google_oauth2(auth)
        end
        self.save
      end

      # USAGE: if you want customize, you just overwrite follow methods.
      def update_by_twitter(auth)
        self.access_token = auth['credentials']['token']
        self.secret = auth['credentials']['secret']
        self.name = auth['info']['nickname']
        self.nickname = auth['info']['nickname']
        self.image_path = auth['info']['image']
      end

      def update_by_facebook(auth)
        self.access_token = auth['credentials']['token']
        self.expires_at = auth['credentials']['expires_at']
        self.email = auth['info']['email']
        self.name = auth['info']['name']
        self.nickname = auth['info']['nickname']
        self.image_path = auth['info']['image']
        self.gender = auth['extra']['raw_info']['gender']
        self.locale = auth['extra']['raw_info']['locale']
      end

      def update_by_github(auth)
        self.email = auth['info']['email']
        self.name = auth['info']['name']
        self.nickname = auth['info']['nickname']
        self.image_path = auth['info']['image']
        self.access_token = auth['credentials']['token']
        self.secret = auth['credentials']['secret']
        self.refresh_token = auth['credentials']['refresh_token']
        self.expires_at = auth['credentials']['expires_at']
      end

      def update_by_google_oauth2(auth)
        self.email = auth['info']['email']
        self.name = auth['info']['name']
        self.access_token = auth['credentials']['token']
        self.refresh_token = auth['credentials']['refresh_token']
        self.expires_at = auth['credentials']['expires_at']
        self.image_path = auth['info']['image']
        self.gender = auth['extra']['raw_info']['gender']
        self.locale = auth['extra']['raw_info']['locale']
      end
    end
  end
end
