class Api::V1::Revenue::MerchantsController < ApplicationController

  def index
  end

  def show
    render json: MerchantRevenueSerializer.new(Merchant.find(params[:id]))
  end
end