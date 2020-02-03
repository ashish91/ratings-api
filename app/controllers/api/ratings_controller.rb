class Api::RatingsController < ApplicationController
  def index
    render json: { error: 'Product not found'}, status: 404 unless Product.exists?(params[:product_id])

    product = Product.find_by(id: params[:product_id])
    ratings = {
        average: product.avg_ratings,
        one_ratings: product.one_ratings,
        two_ratings: product.two_ratings,
        three_ratings: product.three_ratings,
        four_ratings: product.four_ratings,
        five_ratings: product.five_ratings,
    }
    render json: ratings, status: :ok
  end

end
