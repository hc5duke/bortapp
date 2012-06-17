module IndexHelper
  def train_class(train)
   "dest_#{train.destination.downcase} #{opacity_class(train)}"
  end

  def opacity_class(train)
    if train.minutes >= 50
      'future'
    end
  end

  def station_class(station)
    if %w(embr woak).include?(station.origin.downcase)
      'hidden'
    end
  end

  def train_length(train)
    train.length % 10
  end
end
