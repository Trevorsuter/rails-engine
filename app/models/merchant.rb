class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :items

  def self.find_all_by_name(name)
    where("name ILIKE ?", "%#{name}%")
    .order(:name)
  end

  def revenue
    invoice_items.joins(:invoice)
    .where('invoices.status = ?', 'shipped')
    .joins(invoice: :transactions)
    .where('transactions.result = ?', 'success')
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end
end
