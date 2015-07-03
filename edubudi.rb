
require 'mw_dictionary_api'
require 'rest_client'
require 'json'
require 'date'

########################################################################################################
#                                                                                                      #
#           TODO: Get general weather data and format it as if edubudi is talking to user              #
#                                                                                                      #
########################################################################################################

def forecast(city)
    response = RestClient.get "http://api.openweathermap.org/data/2.5/forecast?q=#{city}&units=metric"
    response_hash = JSON.parse response
    status = response_hash.empty?
    status = !status
    if status
        list = response_hash["list"]
        message = "City: #{response_hash["city"]["name"]}\n"
        list.each do |str|
            str_date = str["dt_txt"]#.split(" ")
            #date = str_date[0]
            #time = str_date[1]
            message += "Date: #{str_date}\n" 
            message += "Temp: #{str["main"]["temp"]}\n"
            message += "Max Temp: #{str["main"]["temp_max"]}\n"
            message += "Min Temp: #{str["main"]["temp_min"]}\n"
        end
    else
        message = "Sorry your request could not be processed please try again\n"
    end
    puts message
    message
end

def weathertoday(city)
    response = RestClient.get "http://api.openweathermap.org/data/2.5/weather?q=#{city}&units=metric"
    response_hash = JSON.parse response
    status = response_hash.empty?
    status = !status
    if status
        temp = response_hash["main"]["temp"]
        temp_min = response_hash["main"]["temp_min"]
        temp_max = response_hash["main"]["temp_max"]     
        message = "City: #{response_hash["name"]}\n"
        message+= "Temp: #{response_hash["main"]["temp"]}\n"
        message+= "Max Temp: #{response_hash["main"]["temp_max"]}\n"
        message+= "Min Temp: #{response_hash["main"]["temp_min"]}"
    else
        message = "Sorry your request could not be processed please try again\n"
    end
    puts message
    message
end

def dictionary(searchterm)
    client = MWDictionaryAPI::Client.new(ENV['MERIAM_API'], api_type: "collegiate")
    begin
        message1 = client.search(searchterm)
        messages = message1.to_hash
        messages = messages[:entries].first
        message = "#{messages[:id_attribute]} , Pronunciation: #{messages[:pronunciation]} , Part of speech : #{messages[:part_of_speech]}\nDefinitions: \n"
        messages[:definitions].each do |definition|
            message = message+ "\n#{definition[:sense_number]}#{definition[:text]}"
            if definition[:verbal_illustration]
                message = message + ", Illustration:#{definition[:verbal_illustration]}"
            end
        end
    rescue
        message = "I couldn't find the word, mudhalaali."
        puts "Error"
    end
    return message
end

def twitterupdate(status)
    if status.include?(ENV['EDUBUDI_PASSWORD'])
        status = status.gsub(ENV['EDUBUDI_PASSWORD'],"")
        `sh twitter.sh #{status}`
        return "Successfully updated status."
    else
        return "Status couldn't be updated. Type Help for syntaxes."
    end
end

offset = 0

while 1
    response = RestClient.get "https://api.telegram.org/#{ENV['EDUBUDI_API']}/getUpdates", {:params => {"offset" => offset.to_i+1}}
    updates = JSON.parse(response)["result"]
    updates.each do |update|
        begin
            fir = update["message"]["text"].gsub("@EdubudiBot","").gsub("@edubudibot","").gsub("@Edubudibot","").split(" ")
            # 
            # Here is where we add our api
            #
            #
            #
            command = fir[0].downcase
            if command=="dictionary" 
                message = dictionary(fir[1])
            elsif command=="twitter" 
                message = twitterupdate(update["message"]["text"].gsub("@EdubudiBot","").gsub("@edubudibot","").gsub("@Edubudibot","").gsub("Twitter","").gsub("twitter",""))
            elsif command=="weather" 
                message = weathertoday(fir[1])
            elsif command=="forecast" 
                message = forecast(fir[1])
            else
                message = "Mudhalaali, I take only the following commands. \n ---------- \n Dictionary : 'Dictionary word' \n Twitter : 'Twitter edubudipassword statusupdate' \n Weather : 'Weather cityname' \n 3 day Forecast : 'Forecast cityname'"
            end
            #
            # API appending part has ended!! 
            #
            #
            #
            if message
                xyz= RestClient.get "https://api.telegram.org/#{ENV['EDUBUDI_API']}/sendMessage" ,{:params => {"chat_id"=> update["message"]["chat"]["id"], "text"=> message}}
            end
            if update["update_id"].to_i>offset.to_i
                offset = update["update_id"].to_i
            end
        end
    end
    sleep 1
end
