import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [  
    "vatInput",
    "vatMessage",
    "nameInput",
    "zipInput",
    "cityInput",
    "streetInput",
    "validateButton"
  ];

  connect() {
  }
  
  // Function to get the VAT value from the input fields and send it to /validate_vat - app/controllers/vat_send_controller.rb
  async get_vat() {
  // Clean the form.
    this.nameInputTarget.value = "";
    this.cityInputTarget.value = "";
    this.zipInputTarget.value = "";
    this.streetInputTarget.value = "";
    this.vatMessageTarget.textContent = "";
    this.validateButtonTarget.textContent= "Validating..."
    
  // VAT number must be 9 digits
    if (this.vatInputTarget.value.length === 9) {
    
      const vatNumber = this.vatInputTarget.value;  // Getting the input value from VAT field.  
  
      try {  // Starting the HTTP request, passing vatNumber as param.
        const response = await fetch("/validate_vat", {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": this.getCsrfToken(),
          },
          body: JSON.stringify({ vat_number: vatNumber }),
        });
  
        if (response.ok) {  // Getting the response and setting the targets into entity's keys.
          const data = await response.json();
          const entity_data = data.body;
          
          if (entity_data.valid) {
            this.nameInputTarget.value = entity_data.name;
            this.cityInputTarget.value = entity_data.city;
            this.zipInputTarget.value = entity_data.zip_code;
            this.streetInputTarget.value = entity_data.street_address;
          }
          const messageToDisplay = this.classifyMessage(data.message);
          this.vatMessageTarget.textContent = messageToDisplay.message;
          this.vatMessageTarget.className = messageToDisplay.class;
  
        } else {
          const errorData = await response.json();
          const messageToDisplay = this.classifyMessage(errorData.error);
          this.vatMessageTarget.textContent = messageToDisplay.message;
          this.vatMessageTarget.className = messageToDisplay.class;
        }
      } catch (error) {
        const messageToDisplay = this.classifyMessage(error.message); 
        this.vatMessageTarget.textContent = messageToDisplay.message;
        this.vatMessageTarget.className = messageToDisplay.class;
      }
    } else {
      this.vatMessageTarget.textContent =
        "VAT must be 9 digits";
      this.vatMessageTarget.className = "message-failure";

    }
    this.validateButtonTarget.textContent = "Validate VAT"
  }
  
  classifyMessage(inputMessage) {  // Method that gets as param the message from vat_send_controller and defines the class of the message to display.
    let resultObject = {
      message: inputMessage,
      class: ""
    };

    if (inputMessage && inputMessage === "VAT is valid") {
      resultObject.class = "message-success";
    } else {
      resultObject.class = "message-failure";
    }

    return resultObject;
  }


  getCsrfToken() {  // Get the token from the form head.
    const token = document.querySelector('meta[name="csrf-token"]');
    return token ? token.content : null;
  }
 
}
