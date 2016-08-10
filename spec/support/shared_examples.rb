RSpec.shared_examples "a finder" do
  it "finds the record" do
    is_expected.not_to be_nil
    expect(subject.id).to eq(query_id)
  end
end

RSpec.shared_examples "a nil return" do
  it "returns nil" do
    is_expected.to be_nil
  end
end
