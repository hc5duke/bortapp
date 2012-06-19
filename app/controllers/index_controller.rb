class IndexController < ApplicationController
  def index
    @time = Time.now.in_time_zone('Pacific Time (US & Canada)')
    pm = @time.hour < 4 || @time.hour > 12
    if params[:morning]
      pm = params[:morning] != 'true'
    elsif params[:evening]
      pm = params[:evening] == 'true'
    end
    pm ? evening : morning

    @adjustments = ADJUSTMENTS
  end

  private

  HOME_STATIONS = %w(dubl)
  DOWNTOWN_STATIONS = %w(16th civc powl mont embr woak)
  EASTBOUND_DESTINATIONS = %w(PITT FRMT RICH SHAY DUBL CONC NCON MONT)
  ADJUSTMENTS = Hash[DOWNTOWN_STATIONS.zip([0, 3, 4, 6, 7, 14])]

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
