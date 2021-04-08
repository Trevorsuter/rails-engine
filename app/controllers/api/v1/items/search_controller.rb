class Api::V1::Items::SearchController < ApplicationController

  def index
    if name_search
      find_one_by_name
    elsif min_price_search && valid_price(params[:min_price])
      find_one_by_min_price
    elsif max_price_search && valid_price(params[:max_price])
      find_one_by_max_price
    elsif price_range_search && valid_price(params[:min_price]) && valid_price(params[:max_price])
      find_one_by_price_range
    else
      head :bad_request
    end
  end

  def find_one_by_name
    result = Item.find_one_by_name(params[:name])
    if !result
      render json: NullSerializer.new
    else
      render json: ItemSerializer.new(result)
    end
  end

  def find_one_by_min_price
    result = Item.find_one_by_min_price(params[:min_price])
    if !result
      render json: NullSerializer.new
    else
      render json: ItemSerializer.new(result)
    end
  end

  def find_one_by_max_price
    result = Item.find_one_by_max_price(params[:max_price])
    if !result
      render json: NullSerializer.new
    else
      render json: ItemSerializer.new(result)
    end
  end

  def find_one_by_price_range
    result = Item.find_one_by_price_range(params[:min_price], params[:max_price])
    if !result
      render json: NullSerializer.new
    else
      render json: ItemSerializer.new(result)
    end
  end

  def name_search
    !params[:name].blank? && params[:min_price].blank? && params[:max_price].blank?
  end

  def min_price_search
    !params[:min_price].blank? && params[:name].blank? && params[:max_price].blank?
  end

  def max_price_search
    !params[:max_price].blank? && params[:name].blank? && params[:min_price].blank?
  end

  def price_range_search
    !params[:min_price].blank? && params[:max_price].to_i >= 0 && params[:name].blank?
  end

  def valid_price(price)
    price.to_i >= 0
  end
end