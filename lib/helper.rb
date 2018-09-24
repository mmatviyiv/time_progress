module Helper
  def slack_client(user)
    slack = Slack::Web::Client.new
    slack.token = user.access_token

    slack
  end

  def set_logger_tags(context={})
    context.each do |key, value|
      Rails.logger.push_tags("#{key.downcase}: #{value}") unless value.nil?
    end
  end

  def clear_logger_tags
    Rails.logger.clear_tags!
  end
end