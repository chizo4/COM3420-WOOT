# frozen_string_literal: true

require 'rails_helper'

describe 'Visiting the homepage' do
  context 'as any web app visitor' do
    specify 'can see the sign in button' do
      visit root_path
      expect(page).to have_link('Sign In')
    end
  end
end
