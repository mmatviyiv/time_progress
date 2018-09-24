class Notifier < ApplicationRecord
  after_create :schedule_job
  before_validation :set_user_team
  after_update :schedule_job, if: -> { saved_change_to_cron? }

  belongs_to :user
  belongs_to :team

  enum progress_type: {quarter: 'quarter', year: 'year'}

  scope :active,  -> { where(inactive: false) }
  scope :quarter, -> { where(progress_type: 'quarter') }
  scope :year,    -> { where(progress_type: 'year') }

  validate :time_validation, :timezone_validation, :weekdays_validation, :channel_id_validation

  def disable!
    update_attribute(:inactive, true)
    Resque.remove_schedule(job_identifier)
  end

  def active?
    not inactive
  end

  [:weekdays, :time, :timezone].each do |attr|
    define_method(attr) do
      Cron.new(self.cron).send(attr)
    end

    define_method("#{attr}=") do |value|
      cron = Cron.new(self.cron)
      cron.send("#{attr}=", value)
      self.cron = cron.tabs
    end
  end

  private

  def set_user_team
    self.team = user.team if team.nil?
  end

  def job_identifier
    "#{progress_type}_#{channel_id}"
  end

  def schedule_job
    Resque.set_schedule(job_identifier, {
        class:   'NotifierJob',
        queue:   'default',
        args:    self.id,
        cron:    cron,
        persist: true
    })
  end

  def time_validation
    errors.add(:base, 'Time is invalid') unless /(?:[01]?\d|2[0123]):(?:[012345]\d)/.match?(time)
  end

  def timezone_validation
    errors.add(:base, 'Your browser timezone is invalid') unless ActiveSupport::TimeZone[timezone].present?
  end

  def weekdays_validation
    valid = weekdays.select{|d| (0..6).include?(d.to_i)}
    errors.add(:base, 'Weekday is invalid') if valid != weekdays
    errors.add(:base, 'At least one weekday should be specified') if valid.empty?
  end

  def channel_id_validation
    found = user.slack_channels.select{|ch| ch['id'] == channel_id}.map{|ch| ch['id']}
    active_notifiers = team.notifiers.active.where(progress_type: progress_type).where.not(id: id)
    not_owned = active_notifiers.where.not(user: user)
    owned = active_notifiers.where(user: user)

    if found.empty?
      errors.add(:base, 'Slack channel is invalid')
    elsif owned.map(&:channel_id).include?(found.first)
      errors.add(:base, 'You have used this channel for such type of notifiers already')
    elsif not_owned.map(&:channel_id).include?(found.first)
      errors.add(:base, 'Some one else in your team has used this channel for such type of notifiers already')
    end
  end
end
