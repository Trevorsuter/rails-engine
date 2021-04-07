class Api::V1::ItemsController < ApplicationController

  def index
    @items = ItemSerializer.new(Item.all_paginated(per_page, page))
    render json: @items
  end

  def show
    @item = ItemSerializer.new(Item.find(params[:id]))
    render json: @item
  end

  def create
    @item = Item.create(item_params)
    render json: ItemSerializer.new(@item), status: 201
  end

  def update
    @item = Item.find(params[:id])
    @item.update_attributes(item_params)
    if @item.save
      render json: ItemSerializer.new(@item)
    else
      head :not_found
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
  end

  private
  
  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end