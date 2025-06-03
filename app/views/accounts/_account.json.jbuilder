json.extract! account, :id, :name, :vat, :city, :zipcode, :address, :created_at, :updated_at
json.url account_url(account, format: :json)
