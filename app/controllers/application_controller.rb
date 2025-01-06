# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :set_filter_by_user_id

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name email])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name email])
  end

  def after_sign_in_path_for(_resource)
    health_records_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  private

  def user_not_authorized
    flash[:alert] = t('application.user_not_authorized.failure')
    redirect_back_or_to(root_path)
  end

  def record_not_found(error)
    Rails.logger.debug { "Entity #{error.model} with id #{error.id} is not found." }

    render file: "#{::Rails.root}/public/404.html", status: :not_found
  end

  def set_filter_by_user_id
    @chosen_user_id = session.fetch(:user_id, current_user&.id)
  end
end
