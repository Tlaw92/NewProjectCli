class VehiclePost

  @@all = []

  attr_accessor :title, :price, :city

  def initialize(title, price, city)
    @title = title
    @price = price
    @city = city
  end

  def save
    @@all << self
  end

  def self.all
    @@all
  end


end
