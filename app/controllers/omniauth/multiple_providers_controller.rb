module Omniauth
  class MultipleProvidersController < ApplicationController

    # PATH: new_omniauth_path(provider: 'twitter')
    def new
      if %w[twitter github google_oauth2 facebook].include?(params[:provider])
        redirect_to "/auth/#{params[:provider]}"
      else
        redirect_to root_path, error: "#{params[:provider]}による認証は存在しません"
      end
    end

    def create
      @user = User.find_or_create_by_oauth(env['omniauth.auth'], current_user)
      if @user.new_record?
        redirect_to new_user_session_path, flash: {error: "ユーザデータの保存に失敗しました：#{@user.errors.full_messages.join(', ')}"}
      elsif @user.email.blank?
        redirect_to new_user_registration_path(@user)
      else
        sign_in(@user)
        redirect_to root_path, notice: 'OK'
      end
    end

    def failure
      redirect_to root_path, flash: {error: 'OAuth認証に失敗しました'}
    end

    # PATH: omniauth_path('twitter'), method: :delete
    def destroy
      if up = current_user.provider_users.find_by(provider: params[:id])
        up.destroy
        redirect_to root_path, notice: "#{up.provider}の認証を削除しました。"
      else
        redirect_to root_path, notice: 'Does not exist your provider ID'
      end
    end
  end
end
