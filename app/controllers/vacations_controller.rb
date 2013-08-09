class VacationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter do
    unless current_user && current_user.admin?
      flash[:alert] = 'No tiene permisos para ver este recurso'
      redirect_to :root
    end
  end

  def index
    @vacations = Vacations.all
  end

end
