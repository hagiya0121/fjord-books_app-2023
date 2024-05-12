# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    super do |resource|
      resource.build_profile
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [
                                        { profile_attributes: %i[postal_code address self_introduction] }
                                      ])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
                                        { profile_attributes: %i[id postal_code address self_introduction] }
                                      ])
  end
end
