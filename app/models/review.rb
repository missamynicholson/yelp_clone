class Review < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  has_many :endorsements
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already" }

  def authored_by?(current_user)
    user == current_user
  end


end
