require 'rails_helper'

RSpec.describe DocsController, type: :controller do

  describe "GET #waiver" do
    it "returns http success" do
      get :waiver
      expect(response).to have_http_status(:success)
    end
  end

end
