module IndexHelper
  def opacity_class(train)
    if train.minutes >= 50
      'future'
    end
  end

  def train_length(train)
    train.length % 10
  end
end
