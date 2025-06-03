require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:one) # This loads the 'one' fixture from accounts.yml
  end

  test "visiting the index" do
    visit accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "should create account" do
    visit accounts_url
    click_on "New account" # Or "New Account" if that's the exact text

    # Use unique data for creation to avoid validation errors
    fill_in "Name", with: "New Unique Account Name #{Time.now.to_i}" # Adding timestamp for uniqueness
    fill_in "Vat", with: "NU#{Time.now.to_i}" # Adding timestamp for uniqueness
    fill_in "Address", with: "123 Main St" # Example new data
    fill_in "City", with: "Anytown"
    fill_in "Zipcode", with: "12345"
    
    click_on "Create Account"

    assert_text "Account was successfully created"
    # It's good practice to navigate away or check for the new account on the index page
    # For example, after clicking "Back" or navigating to accounts_url:
    click_on "Back" 
    # assert_text "New Unique Account Name" # Verify it's on the index page
  end

  test "should update Account" do
    visit account_url(@account) # Go to the show page for the specific account

    # Try common variations for the edit button text
    # Or inspect your view to get the exact text or ID
    # e.g., <a href="/accounts/1/edit">Edit Account</a>
    # You can also use an ID: click_on "#edit_account_#{@account.id}"
    click_on "Edit this account", match: :first # Original
    # If the above fails, try:
    # click_on "Edit", match: :first 
    # click_on "Edit Account", match: :first


    # Fill in fields with new, updated data to test the update
    fill_in "Address", with: "456 Updated St"
    fill_in "City", with: "Newcity"
    # You might not want to update name and VAT if they have uniqueness constraints
    # and you're not changing them to something new and unique.
    # fill_in "Name", with: @account.name # No change
    # fill_in "Vat", with: @account.vat # No change
    fill_in "Zipcode", with: "54321"
    
    click_on "Update Account"

    assert_text "Account was successfully updated"
    # Verify the changes persisted
    click_on "Back"
    # visit account_url(@account) # Re-visit the show page
    # assert_text "456 Updated St" # Check if the new address is displayed
  end

  test "should destroy Account" do
    visit account_url(@account) # Go to the show page

    # Handle the JavaScript confirmation dialog
    accept_confirm do
      # Try common variations for the destroy button text
      # Or inspect your view to get the exact text or ID
      click_on "Destroy this account", match: :first # Original
      # If the above fails, try:
      # click_on "Destroy", match: :first
      # click_on "Delete this account", match: :first
    end

    assert_text "Account was successfully destroyed"
    # Optionally, verify the account is no longer in the index
    # visit accounts_url
    # assert_no_text @account.name
  end
end
