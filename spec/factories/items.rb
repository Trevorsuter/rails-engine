FactoryBot.define do
  factory :item do
    name { "MyString" }
    description { "MyString" }
    unit_price { "9.99" }
    association :merchant_id, factory: :merchant

    factory :item_with_invoices do
      
    end
  end
end
