class Account < ApplicationRecord
	validates :name, presence: true, uniqueness: true
	validates :city, presence: true
	validates :zipcode, presence: true, length: {minimum: 5, maximum: 5 }
	validates :address, presence: true
	validates :vat, presence: true, length: {minimum: 9, maximum: 9 }, uniqueness: true
end
