class NotificationsController < ApplicationController
  def index
    @notifications = policy_scope(Prescription)
    @notifications = Notification.where(user: current_user)
  end
end
