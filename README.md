# README

## The process involves several steps for the execution. 

- `app/views/accounts/_form.html.erb`
    - The user enters a VAT number in the VAT input field.
    - The button "Validate VAT" clicked and initiates the get_vat() action in the Stimulus vat_lookup_controller.

- `app/javascript/controllers/vat_lookup_controller.js`
    - It checks if the entered VAT number has a length of 9 digits.
    - If not, it displays an error message ("VAT must be 9 digits") and sets the message class to `message-failure`.
    - It retrieves the CSRF token. 
    - It makes a `fetch` POST request to the `/validate_vat` endpoint on the Rails backend.
    - The request body contains the VAT number as a JSON object.

- The POST request to `/validate_vat` is routed by Rails (as defined in `config/routes.rb`) to the `validate_vat` action in the `VatSendController`.

- `app/controllers/vat_send_controller.rb`
    - It retrieves the `vat_number` from the request parameters.
    - It calls the `VatValidation.sendVatToValidate(vat_number)` method from the app/services/validate_vat.rb VatValidation class. This service class handles the actual communication with the VIES API.
    - If `VatValidation.sendVatToValidate` returns data indicating the VAT is valid:
        - It renders a JSON response with a success message ("VAT is valid"), and the `body` containing the `entity_data`.
    - If the VAT is invalid:
        - It renders a JSON response (but `valid: false`), an error message ("Your VAT is invalid, please check again."), and the `body` containing the `entity_data`.

- `app/services/vat_validation.rb`
    - It prepares the data payload for the VIES API, including the `countryCode` (hardcoded to "EL" for Greece) and the provided `vatNumber`.
    - It calls `self.call_API(data)` to make the HTTP POST request to the VIES API endpoint (`https://ec.europa.eu/taxation_customs/vies/rest-api/check-vat-number`).
    - This class method uses the `Faraday` HTTP client library.
    - If the API call is successful:
    - It parses the JSON response body from VIES.
    - If the parsed `entity_data["valid"]` is true, it calls `self.cleanResponse(entity_data)` to extract and structure the relevant address details.
    - This class method takes the raw successful response from the VIES API.
    - It extracts the `name`, `vatNumber`, `valid` status, and the full `address` string.
    - It returns a hash (`entity_details`) containing these cleaned and structured details.

- `app/javascript/controllers/vat_lookup_controller.js`
    - The `entity` data (name, city, zip, street) is extracted from `data.body`.
    - If `entity.valid` is true:
       - The input fields (`nameInputTarget`, `cityInputTarget`, `zipInputTarget`, `streetInputTarget`) are populated with the values from the `entity` object.

- Based on the outcome, the user sees:
     - A success or error message regarding the VAT validation.
     - If the VAT was valid, the name and address fields (name, city, zip code, street address) are auto-filled with the information retrieved from the VIES API.
   


        