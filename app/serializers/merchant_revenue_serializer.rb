class MerchantRevenueSerializer
  include FastJsonapi::ObjectSerializer
  set_type :merchant_revenue

  attribute :revenue do |object|
    object.revenue
  end
end
