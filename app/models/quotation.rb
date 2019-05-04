class Quotation < ApplicationRecord
  belongs_to :user
  belongs_to :client

  has_many :quotation_products, dependent: :destroy
end
