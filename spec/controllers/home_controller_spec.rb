# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it 'returns http success' do
      sign_in_user

      stub_endpoint :get, %i[client info],
                    response: {
                      status: 200,
                      body:   {
                        data: 'some unrelevant data'
                      }
                    }
      get :index
      expect(response.status).to eql 200
    end
  end
end
