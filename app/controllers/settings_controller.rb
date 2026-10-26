class SettingsController < ApplicationController
  def show
    @user = Current.user
    @devices = @user.devices.order(last_seen_at: :desc)
  end

  def update
    @user = Current.user

    if @user.update(user_params)
      redirect_to settings_path, notice: "Settings saved."
    else
      @devices = @user.devices.order(last_seen_at: :desc)
      render :show, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.expect(user: [ :name, :email_address ])
    end
end
