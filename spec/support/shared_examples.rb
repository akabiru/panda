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

RSpec.shared_examples "a private method provider" do |method_name|
  it "keeps #{method_name} private" do
    expect(Todo.singleton_class.private_method_defined?(method_name)).
      to be true
    expect(Todo.singleton_class.method_defined?(method_name)).to be false
    expect(Todo.method_defined?(method_name)).to be false
  end
end
