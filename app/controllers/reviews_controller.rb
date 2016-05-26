class ReviewsController < ApplicationController

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    restaurant = Restaurant.find(params[:restaurant_id])
    @review = restaurant.reviews.build_with_user(review_params, current_user)

    if @review.save
      redirect_to restaurants_path
    else
      if @review.errors[:user]
        redirect_to restaurants_path, alert: 'You have already reviewed this restaurant'
      else
        render :new
      end
    end
  end

  def index
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def destroy
    restaurant = Restaurant.find(params[:restaurant_id])
    review = restaurant.reviews.find(params[:id])
    if review.authored_by?(current_user)
      review.destroy
      flash[:notice] = 'Review deleted successfully'
    else
      flash[:notice] = "Can't delete this review"
    end
    redirect_to "/restaurants/#{restaurant.id}/reviews"
  end

  private

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
