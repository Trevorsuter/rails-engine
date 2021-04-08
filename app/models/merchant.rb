class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items

  def self.find_all_by_name(name)
    where("lower(name) LIKE ?", "%#{name.downcase}%")
    .order(:name)
  end
end
