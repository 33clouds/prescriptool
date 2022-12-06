class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization

  after_action :verify_authorized, except: :index, unless: :skip_pundit? # to satisfy this verification, we need to use authorize @flat
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit? # to satisfy this verification, we need to use policy_scope(Flat)

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end

