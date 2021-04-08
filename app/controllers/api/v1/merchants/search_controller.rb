class Api::V1::Merchants::SearchController < ApplicationController

  def index
    if params[:name].blank?
      head :bad_request
    else
      render json: MerchantSerializer.new(Merchant.find_all_by_name(params[:name]))
    end
  end
end