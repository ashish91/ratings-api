class RatingsCalculatorService
  def refresh_ratings
    Product.joins(:ratings).includes(:ratings).each do |product|
      ratings = most_recent_ratings_per_user(product)

      count_ratings = count_per_rating(ratings)
      total_ratings = ratings.length

      # Weighted average
      sum = 0
      ratings.each do |rating|
        # Stock Unit will have more than 0 age if it's reused.
        sum += inflate_rating_on_age(rating)
      end
      avg_rating = sum/total_ratings

      # https://math.stackexchange.com/questions/942738/algorithm-to-calculate-rating-based-on-multiple-reviews-using-both-review-score
      # Popular rating is based on number of people who rated. If there are more number of people
      # who rated a product with above average ratings, this ensures it gets more rating than a product
      # with less number of very good ratings.
      moderate = 10
      popular_rating = 5 * (1 - Math.exp(-total_ratings/moderate))

      adjusted_ratings = (avg_rating + popular_rating)/2

      product.update(
          count_ratings: count_ratings.to_json,
          avg_ratings: adjusted_ratings
      )
    end
  end

  private

  def most_recent_ratings_per_user(product)
    product.ratings.includes(:order).select('DISTINCT ON ("user_id") *').order(:user_id, created_at: :desc)
  end

  def count_per_rating(ratings)
    count_ratings = {}
    ratings.pluck(:value).uniq.each do |value|
      count_ratings["#{value}_ratings"] ||= 0
      count_ratings["#{value}_ratings"] += 1
    end

    count_ratings
  end

  def inflate_rating_on_age(rating)
    order = rating.order

    if rating.value > 3 && order.age > 0
      [6, rating.value * (1 + 0.1 * order.age)].min
    else
      rating.value
    end
  end

end
