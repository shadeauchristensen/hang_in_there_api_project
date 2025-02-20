require "rails_helper"

RSpec.describe "Posters API", type: :request do
  describe "index" do
    it "returns all posters in correct json" do
      Poster.create!({
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "./assets/failure.jpg"
      })
      Poster.create!({
        name: "MEDIOCRITY",
        description: "Dreams are just that—dreams.",
        price: 127.00,
        year: 2021,
        vintage: false,
        img_url: "./assets/mediocrity.jpg"
      })
      Poster.create!({
        name: "REGRET",
        description: "Hard work rarely pays off.",
        price: 89.00,
        year: 2018,
        vintage: true,
        img_url: "./assets/regret.jpg"
      })

      get "/api/v1/posters"

      expect(response).to be_successful

      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data).to be_a(Hash) # office hours, is this redundant?
      expect(response_data).to have_key(:data)
      expect(response_data[:data]).to be_a(Array)

      posters = response_data[:data]

      expect(posters.count).to eq(3)

      posters.each do |poster|
        expect(poster).to have_key(:id)
        expect(poster[:id]).to be_a(Integer)

        expect(poster).to have_key(:type)
        expect(poster[:type]).to eq("poster")

        expect(poster).to have_key(:attributes)
        expect(poster[:attributes]).to be_a(Hash)

        attributes = poster[:attributes]

        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to be_a(String)

        expect(attributes).to have_key(:description)
        expect(attributes[:description]).to be_a(String)

        expect(attributes).to have_key(:price)
        expect(attributes[:price]).to be_a(Float)

        expect(attributes).to have_key(:year)
        expect(attributes[:year]).to be_a(Integer)

        expect(attributes).to have_key(:vintage)
        expect(attributes[:vintage]).to be_in([true, false])

        expect(attributes).to have_key(:img_url)
        expect(attributes[:img_url]).to be_a(String)
      end
    end
  end

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

      expect(response_data).to be_a(Hash) # office hours, is this redundant?
      expect(response_data).to have_key(:data)
      expect(response_data[:data]).to be_a(Hash)

      expect(response_data[:data]).to have_key(:id)
      expect(response_data[:data][:id]).to eq(poster_1.id)

      expect(response_data[:data]).to have_key(:type)
      expect(response_data[:data][:type]).to eq("poster")

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

  describe "create" do
    it "can create a new poster" do
      poster_params = {
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "./assets/failure.jpg"
      }
      headers = {"CONTENT_TYPE" => "application/json"} # pass params as JSON rather than plain text

      post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
      created_poster = Poster.last

      expect(response).to be_successful

      expect(created_poster.name).to eq(poster_params[:name])
      expect(created_poster.description).to eq(poster_params[:description])
      expect(created_poster.price).to eq(poster_params[:price])
      expect(created_poster.year).to eq(poster_params[:year])
      expect(created_poster.vintage).to eq(poster_params[:vintage])
      expect(created_poster.img_url).to eq(poster_params[:img_url])

      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data).to be_a(Hash) # office hours, is this redundant
      expect(response_data).to have_key(:data)
      expect(response_data[:data]).to be_a(Hash)

      expect(response_data[:data]).to have_key(:id)
      expect(response_data[:data][:id]).to eq(created_poster.id)

      expect(response_data[:data]).to have_key(:type)
      expect(response_data[:data][:type]).to eq("poster")

      expect(response_data[:data]).to have_key(:attributes)
      expect(response_data[:data][:attributes]).to be_a(Hash)

      attributes = response_data[:data][:attributes]

      expect(attributes).to have_key(:name)
      expect(attributes[:name]).to eq(poster_params[:name])

      expect(attributes).to have_key(:description)
      expect(attributes[:description]).to eq(poster_params[:description])

      expect(attributes).to have_key(:price)
      expect(attributes[:price]).to eq(poster_params[:price])

      expect(attributes).to have_key(:year)
      expect(attributes[:year]).to eq(poster_params[:year])

      expect(attributes).to have_key(:vintage)
      expect(attributes[:vintage]).to eq(poster_params[:vintage])

      expect(attributes).to have_key(:img_url)
      expect(attributes[:img_url]).to eq(poster_params[:img_url])
    end
  end

  describe "update" do
    it "updates a poster using correct json format" do
      poster = Poster.create!({
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "./assets/failure.jpg"
      })

      patch "/api/v1/posters/#{poster.id}",
        params: {poster: {name: "UPDATED", description: "New description."}},
        as: :json
      # This PATCH request sends an update to an existing Posters record at /api/v1/posters/:id, specifying new values for name and description inside the params.
      # The as: :json option ensures the request body is formatted as JSON, so Rails correctly interprets it as an API request. this made my tests pass

      response_data = JSON.parse(response.body, symbolize_names: true)

      expect(response_data[:data][:attributes][:name]).to eq("UPDATED")
      expect(response_data[:data][:attributes][:description]).to eq("New description.")
    end
  end

  describe "destroy" do
    it "deletes a poster using correct json format" do
      poster = Poster.create!({
        name: "FAILURE",
        description: "Why bother trying? It's probably not worth it.",
        price: 68.00,
        year: 2019,
        vintage: true,
        img_url: "./assets/failure.jpg"
      })

      expect(Poster.count).to eq(1)

      delete "/api/v1/posters/#{poster.id}"

      expect(response).to be_successful
      expect(Poster.count).to eq(0)
    end
  end
end
