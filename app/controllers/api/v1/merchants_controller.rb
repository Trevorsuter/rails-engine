class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all.limit(per_page).offset(page))
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end

  private

  def per_page
    params[:per_page] || 20
  end

  def page
    if params[:page] && params[:page].to_i > 0
      (params[:page].to_i - 1) * per_page.to_i
    else
      0
    end
  end
end