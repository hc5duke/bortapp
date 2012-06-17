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

  HOME_STATIONS = %w(dubl)
  DOWNTOWN_STATIONS = %w(16th civc powl mont embr woak)
  EASTBOUND_DESTINATIONS = %w(PITT FRMT RICH SHAY DUBL CONC NCON MONT)

  def morning
    @stations = HOME_STATIONS.map do |abbreviation|
      Bort::Realtime::Estimates.new(abbreviation)
    end

    @destinations = @stations.map(&:destinations).flatten.uniq
  end

  def evening
    @is_evening = true
    @stations = DOWNTOWN_STATIONS.map do |abbreviation|
      Bort::Realtime::Estimates.new(abbreviation)
    end

    @destinations = @stations.map(&:destinations).flatten.uniq - EASTBOUND_DESTINATIONS
  end
end
