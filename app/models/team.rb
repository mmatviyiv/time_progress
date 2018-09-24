class Team < ApplicationRecord
  has_many :users
  has_many :notifiers

  def uninstall!
    users.each {|u| u.revoke!}
    update(uninstalled: true)
  end

  def active?
    not uninstalled
  end
end
