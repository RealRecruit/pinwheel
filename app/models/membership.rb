class Membership < ApplicationRecord
  belongs_to :account
  belongs_to :user

  enum :role, { member: "member", admin: "admin" }, default: :member

  validates :user_id, uniqueness: { scope: :account_id }
end
