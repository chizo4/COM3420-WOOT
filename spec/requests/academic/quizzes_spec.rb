# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Academic::Quizzes', type: :request do
  let!(:academic) { create(:academic) }
  let!(:academic_other) { create(:academic) }
  let!(:quiz) { create(:quiz, academic:) }

  describe 'GET /index' do
    context 'when anyone attempts to access the page' do
      it 'denies permission and returns redirect to new academic session path' do
        get academic_resources_path
        expect(response).to redirect_to(new_academic_session_path)
      end
    end

    context 'when an academic is signed in' do
      before { login_as academic }

      it 'succeeds and returns redirect to academic menu' do
        get academic_resources_path(academic)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /show' do
    context 'when an academic is signed in and it is their quiz' do
      before { login_as academic }

      it 'succeeds and returns renders show' do
        get academic_quiz_path(quiz)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /edit' do
    context 'when an academic is signed in and want to edit their quiz' do
      before { login_as academic }

      it 'succeeds and returns renders edit' do
        get edit_academic_quiz_path(quiz)
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET /new' do
    context 'when an academic is signed and wants to create new quiz' do
      before { login_as academic }

      it 'succeeds and returns renders show' do
        get new_academic_quiz_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
