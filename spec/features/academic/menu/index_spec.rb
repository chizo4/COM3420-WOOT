# frozen_string_literal: true

# TODO: add test cases

require 'rails_helper'

describe 'Visiting the academic menu page' do
  let!(:academic) { build(:academic) }
  let!(:quiz) { create(:quiz, academic:) }

  context 'if not logged in' do
    specify 'cannot visit the page' do
      visit academic_menu_index_path
      expect(page).to have_current_path(new_academic_session_path)
    end
  end

  context 'as a logged in academic user' do
    before do
      login_as(academic)
      visit academic_menu_index_path
    end

    specify 'can view resources' do
      click_on 'Quizzes'
      expect(page).to have_current_path(academic_resources_path(academic))
    end

    specify 'clicking on logo leads to home page' do
      click_on(find('img')['woot_logo.svg'])
      expect(page).to have_current_path(academic_menu_index_path)
    end

    specify 'can see the logout button which works' do
      click_on 'Sign Out'
      expect(page).to have_current_path(root_path)
    end

    # specify 'Can see the action buttons' do
    #     expect(page).to have_link('Create New Quiz')
    # end

    # specify 'create quiz leads to quiz creation page' do
    #     click_on 'Create New Quiz'
    #     expect(page).to have_current_path(new_academic_quiz_path)
    # end
  end
end
