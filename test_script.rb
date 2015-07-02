require 'rest_client'
require 'json'
city = "Madurai"
response = RestClient.get "http://api.openweathermap.org/data/2.5/weather?q=#{city}"
    response_hash = JSON.parse response
    status = response_hash.empty?
    status = !status
    if status
        temp = response_hash["main"]["temp"]
        temp = temp - 273.15
        temp_min = response_hash["main"]["temp_min"]
        temp_min = temp_min - 273.15
        temp_max = response_hash["main"]["temp_max"]
        temp_max = temp_max - 273.15
        message = "It's going to be a #{response_hash["weather"]["main"]} day in #{response_hash["name"]} thalaiva."
        message+= "The average temperature today will be #{response_hash["main"]["temp"]}."
        message+= "You may experience temperatures upto #{response_hash["main"]["temp_max"]} but not less than "
        message+= "Min Temp: #{response_hash["main"]["temp_min"]}"
    else
        message = "Sorry thalaiva. Your Edupudi bot has failed you.\n"
    end
    puts message
    message
