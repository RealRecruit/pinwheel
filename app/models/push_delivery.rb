class PushDelivery < ApplicationRecord
  belongs_to :user
  belongs_to :device

  validates :title, presence: true
end
