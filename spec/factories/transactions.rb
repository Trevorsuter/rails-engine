FactoryBot.define do
  factory :transaction do
    invoice { nil }
    credit_card_number { "MyString" }
    credit_card_expiration { "MyString" }
    result { "MyString" }
  end
end
