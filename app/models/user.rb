class User < ApplicationRecord
  belongs_to :team
  has_many :notifiers

  scope :active, -> { where(revoked: false) }

  devise

  def revoke!
    notifiers.active.each {|c| c.disable!}
    update(revoked: true)
  end

  def active?
    not revoked
  end

  def slack_channels
    cache_path = "channels_#{slack_id}"

    redis = Redis.new(url: ENV['REDIS_URL'], thread_safe: true)
    cache = redis.get(cache_path)

    return JSON.parse(cache) unless cache.nil?

    slack = Slack::Web::Client.new
    slack.token = access_token
    channels = []

    params = {exclude_archived: true, types: 'public_channel,private_channel', sleep_interval: 5, max_retries: 20}
    slack.conversations_list(params) do |response|
      response.channels.each do |c|
        channel = c.slice('id', 'is_private')
        channel['name'] = "##{c['name']}"
        channels.append(channel)
      end
    end

    channels.sort_by!{|ch| ch['name']}
    redis.setex(cache_path, 10*60, channels.to_json)
    channels
  end
end
