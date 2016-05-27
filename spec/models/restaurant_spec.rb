describe Restaurant, type: :model do

  describe "restaurants" do

    it "has correct association with reviews" do
      should have_many(:reviews)
    end

    it "has correct association with user" do
      should belong_to :user
    end

    it "is not valid with a name of less than three characters" do
      restaurant = Restaurant.new(name: "kf")
      expect(restaurant).to have(1).error_on(:name)
      expect(restaurant).not_to be_valid
    end

    it "is not valid unless it has a unique name" do
      Restaurant.create(name: "Moe's Tavern")
      restaurant = Restaurant.new(name: "Moe's Tavern")
      expect(restaurant).to have(1).error_on(:name)
    end

  end

  describe "reviews" do

    describe "build_with_user" do

      let(:user) { User.create email: "test@test.com" }
      let(:restaurant) { Restaurant.create name: "Test" }
      let(:review_params) { {rating: 5, thoughts: "yum"} }

      subject(:review) { restaurant.reviews.build_with_user(review_params, user) }

      it "builds a review" do
        expect(review).to be_a Review
      end

      it "builds a review associated with the specified user" do
        expect(review.user).to eq user
      end

    end

    describe "#average_rating" do
      context "no reviews" do
        it "returns 'N/A' when there are no reviews" do
          restaurant = Restaurant.create(name: "The Ivy")
          expect(restaurant.average_rating).to eq "N/A"
        end
      end

      context "1 review" do
        it "returns that rating" do
          restaurant = Restaurant.create(name: "The Ivy")
          restaurant.reviews.create(rating: 4)
          expect(restaurant.average_rating).to eq 4
        end
      end

      context "multiple reviews" do
        it "returns the average" do
          restaurant = Restaurant.create(name: "The Ivy")
          user = User.create(email: "hello@gmail.com", password:"password")
          restaurant.reviews.create_with_user({rating: 1}, user)
          user2 = User.create(email: "goodbye@gmail.com", password:"password")
          restaurant.reviews.create_with_user({rating: 5}, user2)
          expect(restaurant.average_rating).to eq 3
        end
      end
    end

  end
  it "returns true if the current_user is the creator of the restaurant" do
    user = User.create(email: "test@test.com")
    restaurant = Restaurant.new(user: user)
    expect(restaurant.created_by?(user)).to be true
  end

  it "returns false if the current_user is not the author of the review" do
    user = User.create(email: "test@test.com")
    user2 = User.create(email: "test2@test.com")
    restaurant = Restaurant.new(user: user)
    expect(restaurant.created_by?(user2)).to be false
  end

end
