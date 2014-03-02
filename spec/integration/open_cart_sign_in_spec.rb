require 'spec_helper'

describe "Login" do

  it "should not login with invalid credentials" do
    user = create(:admin_user, email: "test@example.com", password: 'secret222')

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret333'
    click_button 'Login'

    page.should_not have_content("My Account")
  end

  it "should login with existing credentials" do
    user = create(:admin_user, email: "test@example.com", password: 'secret2')

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'secret2'
    click_button 'Login'

    page.should have_content("My Account")
  end

  it "should login with open cart credentials" do
    user = create(:admin_user, email: "test@example.com", encrypted_password: "25d55ad283aa400af464c76d713c07ad")

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678' #Oc Password according to password and salt provided
    click_button 'Login'

    page.should have_content("My Account")
  end

  it "should update credentials after login in with open cart ones" do
    user = create(:admin_user, email: "test@example.com", encrypted_password: "25d55ad283aa400af464c76d713c07ad")

    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678' #Oc Password according to password and salt provided
    click_button 'Login'

    page.should have_content("My Account")

    user.reload
    user.encrypted_password.should_not == "25d55ad283aa400af464c76d713c07ad"

    visit '/logout'
    visit '/login'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: '12345678'
    click_button 'Login'

    page.should have_content("My Account")
  end

end
