FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { "MyString" }
    credit_card_expiration { "MyString" }
    result { 1 }
  end
end
