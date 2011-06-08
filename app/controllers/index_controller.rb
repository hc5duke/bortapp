class IndexController < ApplicationController
  def index
    @stations = %w(16th civc powl mont embr woak).map do |abbreviation|
      Bort::Realtime::Estimates.new(abbreviation)
    end

    @destinations = @stations.map do |station|
      station.destinations
    end.flatten.uniq - %w(PITT FRMT RICH SHAY DUBL)

    @max_length = @stations.map do |station|
      station.trains.select do |train|
        @destinations.include?(train.destination)
      end.map(&:minutes).length
    end.max
  end
end
