class ApplicationController < ActionController::Base
  include Helper
  helper_method Helper.instance_methods

  before_action :authenticate_user!, :update_logger
  after_action -> { clear_logger_tags }

  private

  def update_logger
    set_logger_tags(team: current_user.team.slack_id, user: current_user.slack_id) unless current_user.nil?
  end
end
