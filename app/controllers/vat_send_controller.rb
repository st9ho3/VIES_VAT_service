class VatSendController < ApplicationController
  # Method that gets VAT as a parameter and calls VatValidation.sendVatToValidate()
  # (located in app/services/vat_validation.rb), which makes the call to the VIES API.

  def validate_vat
    vat_number = params[:vat_number]

    begin
      entity_data = VatValidation.sendVatToValidate(vat_number)

      # I send the entity_data to vat_lookup_controller.js as response.
      if entity_data["valid"]
        render json: { valid: true, message: "VAT is valid", body: entity_data }
      else
        render json: { valid: false, message: "Your VAT is invalid, please check again.", body: entity_data }
      end
    rescue StandardError => e
      Rails.logger.error "Error validating VAT: #{e.message}"
      render json: { valid: false, message: "An error occurred during VAT validation. Please try again." }
    end
  end
end
