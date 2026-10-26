class Device < ApplicationRecord
  belongs_to :user
  has_many :push_deliveries, dependent: :destroy

  enum :platform, { ios: "ios", android: "android" }

  validates :platform, :token, presence: true
  validates :token, uniqueness: true

  def platform_name
    ios? ? "iOS" : "Android"
  end
end
