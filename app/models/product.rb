class Product < ApplicationRecord
  has_many :ratings
  has_many :orders
  has_many :stock_units

  [:one, :two, :three, :four, :five].each_with_index do |rating_value, index|
    define_method :"#{rating_value}_ratings" do
      ratings = JSON.parse(count_ratings)
      ratings["#{index + 1}_ratings"] || 0
    end
  end

end
