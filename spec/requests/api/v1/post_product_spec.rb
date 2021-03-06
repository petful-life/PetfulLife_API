require 'rails_helper'

describe 'POST /api/v1/products', :vcr do
    it 'creates a new product with a good request' do
        user = User.create!(id: 1, username: "test_user", email: "test_user123465@test.com", password: "blah")

        test_product_upc = { upc: 888641131105, user_id: 1 }.to_json

        headers = { "CONTENT_TYPE" => "application/json" }

        post "/api/v1/products", headers: headers, params: test_product_upc

        expect(response.status).to eq(201)

        raw_response = JSON.parse(response.body)
        product = Product.find(raw_response["data"]["attributes"]["id"])

        expect(raw_response).to be_a(Hash)
        expect(raw_response["data"]["attributes"]["id"]).to be_a(Integer)
        expect(raw_response["data"]["attributes"]["upc"]).to eq(888641131105)
        expect(raw_response["data"]["attributes"]["name"]).to be_a(String)
        expect(raw_response["data"]["attributes"]["avg_price"]).to be_a(Float)
        expect(user.products).to include(product)
    end

    it 'finds a product if it already exists' do
        user = User.create!(id: 1, username: "test_user", email: "test_user123465@test.com", password: "blah")
        product_1 = Product.create(name: "test_product", upc: 888641131105, avg_price: 1.23)

        headers = { "CONTENT_TYPE" => "application/json" }

        post "/api/v1/products", headers: headers, params: {upc: product_1.upc, user_id: 1 }.to_json

        expect(response.status).to eq(201)
        raw_response = JSON.parse(response.body)

        expect(raw_response["data"]["attributes"]["id"]).to eq(product_1.id)
        expect(raw_response["data"]["attributes"]["upc"]).to eq(product_1.upc)
        expect(raw_response["data"]["attributes"]["name"]).to eq(product_1.name)
        expect(raw_response["data"]["attributes"]["avg_price"]).to eq(product_1.avg_price)
    end

    #sad path
    it 'returns correct error message if product is not found' do
        user = User.create!(id: 1, username: "test_user", email: "test_user123465@test.com", password: "blah")
        test_product_upc = { upc: 10101010101010101, user_id: 1 }.to_json

        headers = { "CONTENT_TYPE" => "application/json" }

        post "/api/v1/products", headers: headers, params: test_product_upc

        expect(response.status).to eq(400)
        raw_response = JSON.parse(response.body)

        expect(raw_response["error"]).to eq("Sorry, that product wasn't found.")
    end
end