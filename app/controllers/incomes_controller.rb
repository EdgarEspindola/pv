class IncomesController < ApplicationController
  def index
    @incomes = Service.where(paid: true).order(updated_at: :desc)
  end

  def pending_services
    @pending_services = Service.where(paid: false).order(updated_at: :desc)
  end
end
