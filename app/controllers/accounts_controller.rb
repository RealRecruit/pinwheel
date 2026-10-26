class AccountsController < ApplicationController
  def index
    @accounts = Current.user.accounts.order(:name)
  end
end
