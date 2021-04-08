class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  def self.find_one_by_name(name)
    where("lower(name) lIKE ?", "%#{name.downcase}%")
    .order(:name)
    .limit(1)
    .first
  end

  def self.find_one_by_min_price(price)
    where('unit_price >= ?', price.to_i)
    .order(:name)
    .limit(1)
    .first
  end

  def self.find_one_by_max_price(price)
    where('unit_price <= ?', price.to_i)
    .order(:name)
    .limit(1)
    .first
  end

  def self.find_one_by_price_range(min, max)
    where(unit_price: min..max)
    .order(:name)
    .limit(1)
    .first
  end
end
