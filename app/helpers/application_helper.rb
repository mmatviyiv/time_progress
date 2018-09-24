module ApplicationHelper
  def build_oauth_url(scope, redirect_uri)
    params = {
        scope:        scope,
        client_id:    ENV['SLACK_APP_ID'],
        redirect_uri: redirect_uri
    }

    uri = URI::HTTPS.build(host: 'slack.com', path: '/oauth/authorize', query: params.to_query)
    uri.to_s
  end

  def add_to_slack_url
    build_oauth_url('chat:write:bot,channels:read,groups:read', slack_oauth_install_url)
  end

  def slack_sign_in_url
    build_oauth_url('identity.basic', slack_oauth_authorize_url)
  end
end
