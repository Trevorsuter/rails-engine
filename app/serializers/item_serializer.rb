class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :unit_price, :merchant_id

  def merchant_id
    self.object.merchant.id
  end
end
