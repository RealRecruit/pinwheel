module AccountScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_account
  end

  private
    def set_account
      Current.account = Current.user.accounts.find(params[:account_id])
    end
end
