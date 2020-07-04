# require_relative "../config/environment.rb"



  class Craigslist::Cli

    include Cities

    def start
      puts "What city would you like to check for vehicles"
      user_input = gets.chomp
      city_comparison_string = user_input.downcase
      city_comparison_string = city_comparison_string.gsub(" ", "")
      if list.index(city_comparison_string)
        Craigslist::Client.scrape_data(city_comparison_string)
        # Craigslist::Client.new(city_comparison_string).run
        ret_val = []
        VehiclePost.all.each_with_index do |vp, index|
          # obj = {title: vp.title, price: vp.price, city: vp.city}
          # ret_val << obj
          puts "#{index},#{vp.title}, #{vp.price}, #{vp.city}"
        end
        # puts ret_val.to_json.inspect
      else
        puts "No Craigslist classified listed for this city"
      end

    end
  end
