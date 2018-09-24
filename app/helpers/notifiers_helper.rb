module NotifiersHelper
  def build_channels_list(channels_list, notifier)
    placeholder = 'Slack channel'
    elements = channels_list.map{|c| [c['name'], c['id']]}
    selected = notifier.channel_id || placeholder

    options_for_select([placeholder] + elements, [selected, disabled: placeholder])
  end

  def build_week_days(notifier)
    days = %w(Sun Mon Tue Wed Thu Fri Sat)

    days.each_with_index.map do |day, i|
      {value: i, name: day, checked: notifier.weekdays.include?(i)}
    end
  end
end
