# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Rating.destroy_all
Order.destroy_all
Product.destroy_all
User.destroy_all

ActiveRecord::Base.transaction do
  5.times do
    User.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email
    )
  end

  10.times do
    product = Product.create!(
        name: Faker::Commerce.product_name,
    )
    StockUnit.create!(
        product: product,
    )
  end

  Product.all.each do |product|
    Order.create!(
        user: User.order('RANDOM()').first,
        product: product,
        stock_unit: product.stock_units.first,
    )
  end

  allowed_ratings = (1..5).to_a
  Order.first(5).each do |order|
    Rating.create!(
        value: allowed_ratings.sample,
        user: order.user,
        product: order.product,
        order: order,
    )
  end
end

