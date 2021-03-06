require 'rails_helper'

describe 'GET api/v1/products/:id' do
    it 'should return the product with the associated ID' do
        product_1 = Product.create(name: "test_product", upc: 330033003300, avg_price: 1.23)

        headers = { "CONTENT_TYPE" => "application/json" }

        get "/api/v1/products/#{product_1.id}", headers: headers

        expect(response.status).to eq(200)

        response_product = JSON.parse(response.body)['data']['attributes']
        expect(response_product['id']).to eq(product_1.id)
        expect(response_product['name']).to eq(product_1.name)
        expect(response_product['upc']).to eq(product_1.upc)
        expect(response_product['avg_price']).to eq(product_1.avg_price)
    end

    #sad path

    it 'should return the appropriate error message if product is not found' do
        product_1 = Product.create(id: 1001, name: "test_product", upc: 330033003300, avg_price: 1.23)

        headers = { "CONTENT_TYPE" => "application/json" }

        get "/api/v1/products/2008", headers: headers

        expect(response.status).to eq(404)
        
        raw_response = JSON.parse(response.body)
        expect(raw_response["error"]).to eq("Sorry, that product wasn't found.")
    end
end