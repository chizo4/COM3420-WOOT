# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the Academic Login page' do
  let!(:academic) { build(:academic) }

  context 'as any web app visitor' do
    specify 'can see the sign in form' do
      visit new_academic_session_path

      expect(page).to have_field('Password')
      expect(page).to have_field('University Username')
      expect(page).to have_button('Sign In')
    end

    specify 'cannot log in with invalid credentials' do
      visit new_academic_session_path

      fill_in 'University Username', with: 'xxx'
      fill_in 'Password', with: 'xxx'
      click_on 'Sign In'

      expect(page).to have_current_path(new_academic_session_path)
    end

    specify 'cannot log in with empty password' do
      visit new_academic_session_path

      fill_in 'University Username', with: 'xxx'
      click_on 'Sign In'

      expect(page).to have_current_path(new_academic_session_path)
    end

    specify 'cannot log in with empty username' do
      visit new_academic_session_path

      fill_in 'Password', with: 'xxx'
      click_on 'Sign In'

      expect(page).to have_current_path(new_academic_session_path)
    end

    specify 'can log in with valid credentials' do
      login_as(academic)
      expect(page).to have_current_path(root_path)
    end
  end
end
