describe Endorsement, type: :model do

  describe "endorsements" do
    it "has correct association with review" do
      should belong_to :review
    end
  end
end
