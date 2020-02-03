class Order < ApplicationRecord
  after_save :determine_age

  belongs_to :user
  belongs_to :product
  belongs_to :stock_unit

  has_many :ratings

  def determine_age
    current_time = Time.current
    age = (current_time.year * 12 + current_time.month) - (stock_unit.created_at.year * 12 + stock_unit.created_at.month)

    update_columns(age: age)
    stock_unit.update_columns(age: age)
  end
end
