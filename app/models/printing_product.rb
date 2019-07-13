=begin
#
# Stores the information of the products
# that are used in impressions sales,
# invitations
#
=end

# == Schema Information
#
# Table name: printing_products
#
#  id             :bigint           not null, primary key
#  bag            :decimal(10, 2)   default(0.0)
#  box            :decimal(10, 2)   default(0.0)
#  code           :string
#  content        :integer
#  imagen         :string
#  increase_stock :integer          default(0)
#  meter          :decimal(10, 2)   default(0.0)
#  name           :string
#  package        :decimal(10, 2)   default(0.0)
#  piece          :decimal(10, 2)   default(0.0)
#  product_type   :string
#  purchase_price :decimal(10, 2)   default(0.0)
#  purchase_unit  :string
#  roll           :decimal(10, 2)   default(0.0)
#  set            :decimal(10, 2)   default(0.0)
#  stock          :integer
#  utility        :decimal(, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PrintingProduct < ApplicationRecord
  mount_uploader :imagen, ImagenUploader

  validates :code, presence: true, uniqueness: {case_sensitive: true}
  validates :name, presence: true, uniqueness: {case_sensitive: true}
  validates :content, :purchase_price, :purchase_unit, :stock, presence: true

  # Search catalog index
  def self.search_index(term)
    where('LOWER(code) LIKE :term or LOWER(name) LIKE :term', term: "%#{term.downcase}%") if term.present?
  end

  def self.product_types
    %w(Hoja Liston Perlas Celofan Flor Grabado Tul Accesorios)
  end

end
