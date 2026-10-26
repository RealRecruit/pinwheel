class Dev::PushDeliveriesController < ApplicationController
  def index
    @push_deliveries = PushDelivery.includes(:user, :device).order(created_at: :desc).limit(50)
  end
end
