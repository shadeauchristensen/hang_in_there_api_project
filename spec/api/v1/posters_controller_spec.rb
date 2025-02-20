require "rails_helper"

RSpec.describe "Posters API", type: :request do
  before do
    @poster = Poster.create!(
      name: "FAILURE",
      description: "Why bother trying? It's probably not worth it.",
      price: 68.00,
      year: 2019,
      vintage: true,
      img_url: "./assets/failure.jpg"
    )
  end

  def parsed_response
    JSON.parse(response.body, symbolize_names: true)
  end

  describe "index" do
    it "returns all posters in correct json" do
      get "/api/v1/posters"

      expect(response).to be_successful

      response_data = parsed_response

      # expect(response_data).to be_a(Hash) # office hours, is this redundant?
      expect(response_data).to have_key(:data)
      expect(response_data[:data]).to be_a(Array)

      posters = response_data[:data]

      expect(posters.count).to eq(1)

      posters.each do |poster|
        expect(poster).to have_key(:id)
        expect(poster[:id]).to be_a(String)

        expect(poster).to have_key(:type)
        expect(poster[:type]).to eq("poster")

        expect(poster).to have_key(:attributes)
        expect(poster[:attributes]).to be_a(Hash)

        attributes = poster[:attributes]

        expect(attributes).to include(
          name: @poster.name,
          description: @poster.description,
          price: @poster.price,
          year: @poster.year,
          vintage: @poster.vintage,
          img_url: @poster.img_url
        )
      end

      expect(response_data).to have_key(:meta)
      expect(response_data[:meta]).to be_a(Hash)

      expect(response_data[:meta]).to include(count: 1)
    end

    describe "sort param" do
      it "sorts in ascending order by default" do
        get "/api/v1/posters"

        posters = parsed_response[:data]

        expect(posters.sort_by! do |poster|
          poster[:attributes][:created_at]
        end).to eq(parsed_response[:data])
      end
    end
  end

  describe "show" do
    it "returns a single poster in correct json format" do
      get "/api/v1/posters/#{@poster.id}"

      expect(response).to be_successful

      response_data = parsed_response

      expect(response_data[:data]).to include(
        id: @poster.id.to_s,
        type: "poster"
      )

      expect(response_data[:data][:attributes]).to include(
        name: @poster.name,
        description: @poster.description,
        price: @poster.price,
        year: @poster.year,
        vintage: @poster.vintage,
        img_url: @poster.img_url
      )
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

      expect(response).to be_successful

      created_poster = Poster.last

      expect(created_poster).to have_attributes(poster_params)

      response_data = parsed_response

      expect(response_data[:data]).to include(
        id: created_poster.id.to_s,
        type: "poster"
      )

      expect(response_data[:data][:attributes]).to include(poster_params)
    end
  end

  describe "update" do
    it "updates a poster using correct json format" do
      updated_params = {"poster" => {"name" => "UPDATED", "description" => "New description."}}

      patch "/api/v1/posters/#{@poster.id}", params: updated_params, as: :json
      # This PATCH request sends an update to an existing Posters record at /api/v1/posters/:id, specifying new values for name and description inside the params.
      # The as: :json option ensures the request body is formatted as JSON, so Rails correctly interprets it as an API request. this made my tests pass

      expect(response).to be_successful

      response_data = parsed_response

      expect(response_data[:data][:attributes]).to include(
        name: "UPDATED",
        description: "New description."
      )
    end
  end

  describe "destroy" do
    it "deletes a poster using correct json format" do
      expect(Poster.count).to eq(1)

      delete "/api/v1/posters/#{@poster.id}"

      expect(response).to be_successful
      expect(Poster.count).to eq(0)
    end
  end
end
