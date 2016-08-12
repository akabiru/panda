require 'spec_helper'

describe Panda do
  let(:test_app) { Panda::Application.new }

  it 'has a version number' do
    expect(Panda::VERSION).not_to be nil
  end

  describe Panda::Application do
    let!(:req) do
      make_request(Rack::MockRequest.env_for("http://example.com:8080/"))
    end

    it "processes request with #call" do
      expect(test_app).to respond_to(:call)
    end
  end
end
