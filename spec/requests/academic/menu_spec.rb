# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Academic::Menu', type: :request do
  describe 'GET /index' do
    context 'when anyone attempts to access the page' do
      it 'denies permission and returns redirect to new academic session path' do
        get academic_menu_index_path
        expect(response).to redirect_to(new_academic_session_path)
      end
    end

    context 'when an academic is signed in' do
      let!(:academic) { create(:academic) }
      before { login_as academic }

      it 'succeeds and returns redirect to academic menu' do
        get academic_menu_index_path(academic)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
