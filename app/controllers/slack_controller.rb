class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!

  def create
    team_id = params['team_id']
    user_id = params['event']['tokens']['oauth'].first rescue nil
    set_logger_tags(team: team_id, user: user_id)

    event_type = params.fetch('event', params)['type']

    case event_type
    when 'url_verification'
      logger.info 'event url verified'
    when 'tokens_revoked'
      User.find_by_slack_id(user_id).revoke!
      logger.info 'access token has been revoked'
    when 'app_uninstalled'
      Team.find_by_slack_id(team_id).uninstall!
      logger.info 'application has been uninstalled'
    else
      logger.info "unhandled event type: #{event_type}"
    end

    render plain: params['challenge']
  end
end
