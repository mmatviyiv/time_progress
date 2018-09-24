class NotifiersController < ApplicationController
  def index
    @channels_list = current_user.slack_channels
    @all_notifiers = current_user.notifiers.active
  end

  def create
    @notifier = current_user.notifiers.create(notifier_params)

    if @notifier.persisted?
      flash[:info] = 'notifier has been created'
      redirect_to action: :index
    else
      @channels_list = current_user.slack_channels
      @all_notifiers = current_user.notifiers.active
      render 'index'
    end
  end

  def update
    notifier = current_user.notifiers.find(params[:id])
    notifier.update(notifier_params)

    flash[:info] = 'notifier has been updated'
    redirect_to action: :index
  end

  def destroy
    notifier = current_user.notifiers.find(params[:id])

    if notifier.nil?
      logger.error 'notifier not found'
      flash[:error] = 'notifier not found'
    else
      notifier.disable!
      logger.info 'notifier has been removed'
      flash[:info] = 'notifier has been removed'
    end

    redirect_to action: :index
  end

  private

  def notifier_params
    params.permit(:channel_id, :progress_type, :time, :timezone, weekdays: [])
  end
end
