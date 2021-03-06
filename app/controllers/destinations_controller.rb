class DestinationsController < ApplicationController
  def index
    @categories = params[:destination][:category]
    @price = params[:destination][:price].to_f
    @price = 100 if @price.zero?
    location = "Copenhagen"
    @categories = ["beer", "wine"] if @categories == [""]
    @destinations = Destination.near(location, 3)
    @destinations_and_menu_items = @destinations.map do |destination|
      { destination => destination.filtered_menu_items(@categories, @price) }
    end.reject { |hash| hash.values.first.empty? }
  end

  def show
    @destination = Destination.find(params[:id])
    @destination_cordinates = { lat: @destination.latitude, lng: @destination.longitude }
    @markers = [[@destination.id, @destination.latitude, @destination.longitude, @destination.name]]
  end

  def map
    @destination_ids = params[:destinations]
    @destination_ids.each do |destination_id|
      destination = Destination.find(destination_id)
      (@markers ||= []).push([destination.id, destination.latitude, destination.longitude, destination.name])
    end
  end
#     @hash = Gmaps4rails.build_markers(@destinations) do |destination, marker|
#       marker.lat destination.latitude
#       marker.lng destination.longitude

  def destination_params
    params.require(:product).permit(:name, :address, :category, :open_hours, :close_hours, :photo)
  end
end

