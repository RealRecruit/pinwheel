class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :accounts, through: :memberships
  has_many :assignments, dependent: :destroy
  has_many :assigned_projects, through: :assignments, source: :project
  has_many :devices, dependent: :destroy
  has_many :push_deliveries, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  def admin_of?(account)
    memberships.admin.exists?(account: account)
  end

  def first_name
    name.split.first
  end
end
