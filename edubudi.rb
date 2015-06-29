require 'mw_dictionary_api'
require 'rest_client'


def dictionary(searchterm)
    client = MWDictionaryAPI::Client.new(ENV['MERIAM_API'], api_type: "collegiate")
    begin
        message1 = client.search(searchterm)
        messages = message1.to_hash
        messages = messages[:entries].first
        puts messages
        message = "#{messages[:id_attribute]} , Pronunciation: #{messages[:pronunciation]} , Part of speech : #{messages[:part_of_speech]}\n"
    rescue
        message = "I couldn't find the word mudhalaali."
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
while 1
    offset = ""
    File.open "offset","r" do |a|
        offset = offset+ a.read
    end
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
            if fir[0]=="dictionary" or fir[0]=="Dictionary"
                message = dictionary(fir[1])
            elsif fir[0]=="twitter" or fir[0]=="Twitter"
                message = twitterupdate(update["message"]["text"].gsub("@EdubudiBot","").gsub("@edubudibot","").gsub("@Edubudibot","").gsub("Twitter","").gsub("twitter",""))
            else
                message = "Mudhalaali, I take only the following commands. \n ---------- \n Dictionary : 'Dictionary word' \n Twitter : 'Twitter edubudipassword statusupdate'"
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
                File.open "offset","w" do |file|
                    file.write update["update_id"]
                end
            end
        end
    end
    sleep 1
end
