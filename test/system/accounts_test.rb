require "application_system_test_case"

class AccountsTest < ApplicationSystemTestCase
  setup do
    @account = accounts(:one)
  end

  test "visiting the index" do
    visit accounts_url
    assert_selector "h1", text: "Accounts"
  end

  test "should create account" do
    visit accounts_url
    click_on "New account"

    fill_in "Address", with: "ΑΘΗΝΑΓΟΡΑ ΜΙΚΡΟΥ 56"
    fill_in "City", with: "ΑΘΗΝΑ"
    fill_in "Name", with: "ΧΑΤΧΙΠΑΥΛΟΥ ΟΥΡΑΝΙΟΣ"
    fill_in "Vat", with: "426145342"
    fill_in "Zipcode", with: "52835"
    click_on "Create Account"

    assert_text "Account was successfully created"
    click_on "Back"
  end

  test "should update Account" do
    visit account_url(@account)
    click_on "Edit", match: :first

    fill_in "Address", with: @account.address
    fill_in "City", with: @account.city
    fill_in "Name", with: @account.name
    fill_in "Vat", with: @account.vat
    fill_in "Zipcode", with: @account.zipcode
    click_on "Update Account"

    assert_text "Account was successfully updated"
    click_on "Back"
  end

  test "should destroy Account" do
    visit account_url(@account)
    click_on "Delete", match: :first

    assert_text "Account was successfully destroyed"
  end
end
