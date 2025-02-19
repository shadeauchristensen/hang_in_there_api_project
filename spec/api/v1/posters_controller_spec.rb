require "rails_helper"

RSpec.describe "Posters API", type: :request do
  describe "show" do
    it "returns a single poster in correct json format" do
      poster_1 = Poster.create!({ # ! is used for error handling
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "./assets/failure.jpg"
      })

      get "/api/v1/posters/#{poster_1.id}"

      expect(response).to be_successful

      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data).to be_a(Hash) # office hours, is this redundant
      expect(response_data).to have_key(:data)
      expect(response_data[:data]).to be_a(Hash)

      expect(response_data[:data]).to have_key(:id)
      expect(response_data[:data][:id]).to eq(poster_1.id)

      expect(response_data[:data]).to have_key(:type)
      expect(response_data[:data][:type]).to eq("Poster")

      expect(response_data[:data]).to have_key(:attributes)
      expect(response_data[:data][:attributes]).to be_a(Hash)

      attributes = response_data[:data][:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to eq("FAILURE")

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to eq("Why bother trying? It's probably not worth it.")

      expect(attributes).to have_key(:price)
      expect(attributes[:price]).to eq(68.00)

      expect(attributes).to have_key(:year)
      expect(attributes[:year]).to eq(2019)

      expect(attributes).to have_key(:vintage)
      expect(attributes[:vintage]).to eq(true)

      expect(attributes).to have_key(:img_url)
      expect(attributes[:img_url]).to eq("./assets/failure.jpg")
    end
  end
end
