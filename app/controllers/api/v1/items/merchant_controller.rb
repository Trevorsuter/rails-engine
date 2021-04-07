class Api::V1::Items::MerchantController < ApplicationController

  def index
    @merchant = MerchantSerializer.new(Item.find(params[:id]).merchant)
    render json: @merchant
  end
end