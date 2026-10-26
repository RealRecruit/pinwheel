class Assignment < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user_id, uniqueness: { scope: :project_id }
  validate :user_is_account_member

  private
    def user_is_account_member
      if user && project && !project.account.users.exists?(user.id)
        errors.add(:user, "isn't a member of this account")
      end
    end
end
