feature "reviewing" do
  let!(:restaurant) { Restaurant.create name: "KFC" }

  scenario "allows users to leave a review using a form" do
     leave_review("so so", 3)
     click_link "KFC Reviews"
     expect(current_path).to eq "/restaurants/#{restaurant.id}/reviews"
     expect(page).to have_content("so so")
  end

  scenario 'displays an average rating for all reviews' do
    sign_up
    leave_review("so so", "3")
    click_link "Sign out"
    sign_up("test@test.com", "pass")
    leave_review("Great", "5")
    expect(page).to have_content("Average rating: ★★★★☆")
  end

  describe "view reviews for each restaurant" do
    scenario "view list of reviews for that restaurant" do
      sign_up
      leave_review("yum", "3")
      visit "/restaurants"
      click_link "KFC Reviews"
      expect(page).to have_content("KFC")
      expect(current_path).to eq "/restaurants/#{restaurant.id}/reviews"
      expect(page).to have_content("yum")
    end

  end

  describe "deleting reviews" do
    scenario "delete my own review" do
      leave_review("so so", 3)
      click_link "KFC Reviews"
      click_link "Delete so so"
      expect(page).not_to have_content "so so"
      expect(page).to have_content "Review deleted successfully"
    end

    describe "delete not my own review" do
      scenario "doesn't delete the review" do
        sign_up
        leave_review("yum", "3")
        click_link "Sign out"
        sign_up("test@test.com", "pass")
        visit "/restaurants"
        click_link "KFC Reviews"
        expect(page).not_to have_content "Delete yum"
      end
    end
  end

  def sign_up(email = "test2@test.com", password = "testtest")
    visit "/"
    click_link("Sign up")
    fill_in("Email", with: email)
    fill_in("Password", with: password)
    fill_in("Password confirmation", with: password)
    click_button("Sign up")
  end

  def leave_review(thoughts, rating)
    visit "/restaurants"
    click_link "Review KFC"
    fill_in "Thoughts", with: thoughts
    select rating, from: "Rating"
    click_button "Leave Review"
  end

end
