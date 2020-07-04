require "nokogiri"
require "httparty"



  class Craigslist::Client

    def self.scrape_data(city_name)
      obj = Craigslist::Client.new(city_name)
      obj.run
    end

    def initialize(city_name)
      @url = "https://#{city_name}.craigslist.org/d/cars-trucks/search/cta"
      @city = city_name
    end

    def run
      response = HTTParty.get(@url)
      nokogiri_doc = Nokogiri::HTML(response)
      total_count = Integer(nokogiri_doc.css(".totalcount").text)
      current_count = 0
      if total_count > 120
        while current_count < total_count do
          break if nokogiri_doc.css(".result-row").length < 1
          # puts current_count.inspect
           parse_page(nokogiri_doc)
           current_count += 120
           response = HTTParty.get(@url + "?s=" + current_count.to_s)
           nokogiri_doc = Nokogiri::HTML(response)
        end
      else
        parse_page(nokogiri_doc)
      end


    end

    def parse_page(nokogiri_doc)
      list_items = nokogiri_doc.css(".result-row")
      list_items.each do |list_item|
        price = list_item.css(".result-price").first.text
        # puts price.inspect
        title = list_item.css(".result-title").text
        # puts title.inspect
        vehicle = VehiclePost.new(title, price, @city)
        vehicle.save
      end
    end


  end
