class IndexController < ApplicationController
  def index
    if params[:morning]
      hour = params[:morning] == 'true' ? 0 : 23
    elsif params[:evening]
      hour = params[:evening] == 'true' ? 23 : 0
    else
      hour = Time.now.in_time_zone('Pacific Time (US & Canada)').hour
    end
    hour < 12 ? morning : evening
  end

private
  def morning
    @stations = %w(dubl).map do |abbreviation|
      Bort::Realtime::Estimates.new(abbreviation)
    end

    @destinations = @stations.map do |station|
      station.destinations
    end.flatten.uniq
  end

  def evening
    @is_evening = true
    @stations = %w(16th civc powl mont embr woak).map do |abbreviation|
      Bort::Realtime::Estimates.new(abbreviation)
    end

    @destinations = @stations.map do |station|
      station.destinations
    end.flatten.uniq - %w(PITT FRMT RICH SHAY DUBL CONC NCON MONT)
  end
end
