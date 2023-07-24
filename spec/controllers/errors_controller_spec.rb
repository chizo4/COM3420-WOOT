# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ErrorsController, type: :request do
  describe '#show' do
    context 'when the status code is 404' do
      it 'renders the 404 template' do
        get '/non_existent'
        expect(response).to have_http_status(404)
        # expect(response).to render_template('views/errors/404.html.haml')
        # expect(page).to have_content('404')
      end
    end

    # context 'when the status code is 403' do
    #   it 'renders the 403 template' do
    #     get :show, params: { status_code: 403 }
    #     expect(response).to have_http_status(403)
    #     expect(response).to render_template('views/errors/403.html.haml')
    #   end
    # end

    # context 'when the status code is 500' do
    #   it "renders the 500 error page" do
    #       allow_any_instance_of(ErrorsController).to receive(:view_for_code).and_return('500')
    #       get "/some-resource-that-causes-an-exception"
    #       expect(response.status).to eq(500)
    #   end
    # end

    # context 'when the status code is not supported' do
    #   it 'renders the 404 template by default' do
    #     get :show, params: { status_code: 401 }
    #     expect(response).to have_http_status(404)
    #     expect(response).to render_template('404')
    #   end
    # end
  end
end
