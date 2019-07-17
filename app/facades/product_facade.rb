class ProductFacade
    attr_reader :id,
                :name,
                :avg_price,
                :upc

    def initialize(upc)
        @upc = upc
        @id = product[:id]
        @name = product[:name]
        @avg_price = product[:avg_price]
    end

    def product
        db_product = Product.find_by(upc: @upc)
        return db_product if db_product
        new_product
    end

    private

        def new_product
            product = Product.create(name: raw_product['title'],
                           upc: @upc,
                           avg_price: raw_product['price']['value'].to_f
            )
            product
        end

        def raw_product
            @_raw_product ||= get_ebay_product.response['itemSummaries'].first
        end

        def get_ebay_product
            @_get_ebay_product ||= EbayService.new(@upc)
        end
end