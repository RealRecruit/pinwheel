class Project < ApplicationRecord
  belongs_to :account
  belongs_to :creator, class_name: "User", default: -> { Current.user }

  has_many :assignments, dependent: :destroy
  has_many :assigned_users, through: :assignments, source: :user
  has_many :comments, dependent: :destroy

  scope :active, -> { where(archived_at: nil) }
  scope :archived, -> { where.not(archived_at: nil) }

  validates :name, presence: true

  def archived?
    archived_at.present?
  end

  def archive
    update!(archived_at: Time.current)
  end

  def assignable_users
    account.users.where.not(id: assigned_users).order(:name)
  end
end
