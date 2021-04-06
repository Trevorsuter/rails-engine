class Api::V1::ItemsController < ApplicationController

  def index
    @items = ItemSerializer.new(Item.all.limit(per_page).offset(page))
    render json: @items
  end

  def show
    @item = ItemSerializer.new(Item.find(params[:id]))
    render json: @item
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