class ProductSerializer
    include FastJsonapi::ObjectSerializer

    attributes :id, :name, :avg_price, :upc
end