class Comment < ApplicationRecord
  belongs_to :project, touch: true
  belongs_to :creator, class_name: "User", default: -> { Current.user }

  validates :body, presence: true

  scope :chronologically, -> { order(:created_at, :id) }

  after_create_commit :notify_assigned_users

  private
    def notify_assigned_users
      project.assigned_users.where.not(id: creator_id).each do |user|
        CommentMailer.with(comment: self, recipient: user).created.deliver_later
      end
    end
end
