feature "endorsing reviews" do
  let!(:kfc) { Restaurant.create(name: "KFC") }
  before do
    kfc.reviews.create(rating: 3, thoughts: "It was an abomination")
  end

  scenario "a user can endorse a review, which updates the review endorsement count", js: true do
    visit "/restaurants/#{kfc.id}/reviews"
    click_link "Endorse Review"
    expect(page).to have_content("1 endorsement")
  end

end
