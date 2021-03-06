class Api::V1::PetProductsController < ApplicationController
    def show
      facade = PetProductFacade.new(params)
    if facade.user == nil
      render :json => { :error => "User not found" }, status: 404
    elsif facade.pet == nil || facade.user.pets.exclude?(facade.pet)
      render :json => { :error => "Pet not found" }, status: 404
    elsif facade.product == nil
      render :json => { :error => "Product not found" }, status: 404
    elsif facade.user && facade.user.pets.include?(facade.pet)
        render json: PetProductSerializer.new(facade), status: 200
      else
        render :json => { :error => "Bad Request" }, status: 400
      end
    end

    def create
      pet = pet_exist?(params[:pet_id])
      product = product_exist?(params[:id])
      user = user_exist?(params[:user_id])
      if user && pet && product
        pet.products << product
        render status: 204
      elsif user == nil
        render status: 404, json: { error: "User not found." }
      elsif pet == nil
        render status: 404, json: { error: "Pet not found." }
      elsif product == nil
        render status: 404, json: { error: "Product not found." }
      else
        render status: 400, json: { error: "Bad request." }
      end
    end

    def update
      product = product_exist?(params[:id])
      pet = pet_exist?(params[:pet_id])
      gb = good_or_bad(update_params[:good_or_bad])
      if pet && product && pet.products.include?(product) && gb != 0
        pet_product = PetProduct.find_by(product_id: params[:id], pet_id: params[:pet_id])
        pet_product.update(good_or_bad: gb, notes: update_params[:notes])
        render status: 202
      elsif pet.nil?
        render status: 404, json: { error: "Pet not found." }
      elsif product.nil?
        render status: 404, json: { error: "Product not found." }
      elsif pet.products.exclude?(product)
        render status: 404, json: { error: "Product does not belong to that pet, please make a post request first."}
      elsif gb == 0
        render status: 400, json: { error: "You must pass either good or bad as a single string." } 
      else
        render status: 400, json: { error: "Bad request" }
      end
    end

    private

      def update_params
        params.require(:pet_product).permit(:good_or_bad, :notes)
      end

      def good_or_bad(text)
        begin
          t = text.downcase.to_sym
          enumerator = {
            "good": true,
            "bad": false
          }
          raise "error" if enumerator[t] == nil
          enumerator[t]
        rescue
          0
        end
      end

end
