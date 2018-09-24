class MainController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def authorize
    oauth = oauth_access(params['code'], slack_oauth_authorize_url)
    set_logger_tags(team: oauth['team']['id'], user: oauth['user']['id'])

    user = User.active.find_by_slack_id(oauth['user']['id'])

    if user.nil?
      logger.warn 'identified a user without application'
      flash[:alert] = 'You has not installed the slack application yet'
      redirect_to root_path
    else
      user.update(access_token: oauth['access_token'], name: oauth['user']['name'])
      sign_in(user)
      redirect_to notifiers_path
    end

  end

  def install
    oauth = oauth_access(params['code'], slack_oauth_install_url)
    set_logger_tags(team: oauth['team_id'], user: oauth['user_id'])

    team = Team.find_or_initialize_by(slack_id: oauth['team_id'])
    team.update(name: oauth['team_name'], uninstalled: false)

    user = team.users.active.find_or_initialize_by(slack_id: oauth['user_id'])

    unless user.new_record?
      logger.warn 'replaced the current active user with a new install'
      flash[:warning] = 'You already had installed the slack application before'
    end

    user.update(access_token: oauth['access_token'])
    sign_in(user)

    redirect_to notifiers_path
  end

  private

  def oauth_access(code, redirect_uri)
    slack = Slack::Web::Client.new
    slack.oauth_access(
        client_id:     ENV['SLACK_APP_ID'],
        client_secret: ENV['SLACK_APP_SECRET'],
        code:          code,
        redirect_uri:  redirect_uri
    )
  end
end
