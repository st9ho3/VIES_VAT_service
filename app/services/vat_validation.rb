class VatValidation

  API_URI = URI.parse("https://ec.europa.eu/taxation_customs/vies/rest-api/check-vat-number")
  COUNTRY_CODE = "EL" # Hardcoded country code for Greece

  def self.sendVatToValidate(vat)
    
    data = {
      countryCode: COUNTRY_CODE,
      vatNumber: vat
    }
  
    begin
      response = call_API(data)  #Make the call to the API

      if response.success?
        
        entity_data = JSON.parse(response.body)
  
        if entity_data["valid"]
          cleanResponse(entity_data) # Clean and extract relevant details if VAT is valid
        else
          entity_data # Return raw details if VAT is invalid
        end
      else
        Rails.logger.error(response.status) 
        Rails.logger.error("Response Message: #{response.reason_phrase}")
        nil # Return nil on API error
      end
    rescue StandardError => e
      Rails.logger.error("A general error occurred: #{e.message}") # Catch and log any general exceptions
      nil 
    end
  end

  
  private 

  def self.call_API(params) #Actual method that does the call. 
   conn = Faraday.new(url: API_URI)

       conn.post do |req|
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
  end

  def self.cleanResponse(response)
    address = response["address"]
    name = response["name"]
    vat = response["vatNumber"]
    valid = response["valid"]

    # Use regex to extract street address, zip code, and city from the 'address' string
    street_address_match = address.match(/^(.*?)\s{2,}/)
    zip_code_match = address.match(/\b(\d{5})\b/)
    city_match = address.match(/-.?([Α-Ω]+)/)

    street_address = street_address_match ? street_address_match[1] : nil
    zip_code = zip_code_match ? zip_code_match[1] : nil
    city = city_match ? city_match[1] : nil

    # Structure the cleaned entity details
    entity_details = {
      "name" => name,
      "vat" => vat,
      "street_address" => street_address,
      "zip_code" => zip_code,
      "city" => city,
      "valid" => valid
    }

    entity_details # Return the cleaned hash
  end
end