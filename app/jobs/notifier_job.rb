class NotifierJob
  extend Helper

  def self.perform(notifier_id)
    notifier = Notifier.find(notifier_id)
    set_logger_tags(team: notifier.team.slack_id, user: notifier.user.slack_id)
    Rails.logger.info 'launching notifier job'

    period = notifier.progress_type.titleize.constantize.new
    bar = Visualizer.new(period.progress, 20,'_', '#')
    message = "[#{bar.print}] #{period.progress}%"

    slack = slack_client(notifier.user)
    slack.chat_postMessage(channel: notifier.channel_id, text: message, username: "#{period.name} progress")

    Rails.logger.info 'notifier job is finished'
  end
end