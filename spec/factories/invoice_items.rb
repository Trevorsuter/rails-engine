FactoryBot.define do
  factory :invoice_item do
    item { nil }
    invoice { nil }
    quantity { 1 }
    unit_price { "9.99" }
  end
end
