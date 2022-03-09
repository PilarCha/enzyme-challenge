class DistanceController < ApplicationController
  def index

  end

  def search
    food_trucks = find_trucks(params[:keyword])

    unless food_trucks
      flash[:alert] = 'No food trucks were found'
      return render action: :index
end
