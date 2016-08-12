require "spec_helper"

RSpec.describe Panda::Routing::Mapper do
  let(:router) { make_router }
  let(:mapper) { Panda::Routing::Mapper.new(router.endpoints) }

  it "initializes @endpoints" do
    expect(mapper.endpoints).not_to be_nil
  end

  describe "#perform" do
    let!(:req) do
      make_request(Rack::MockRequest.env_for("http://example.com:8080/foo"))
    end
    let!(:handler) { mapper.perform(req) }

    it "sets @request" do
      expect(mapper.request).to eq(req)
    end

    it "maps the path" do
      expect(handler).to eq(
        pattern: [%r{^/foo$}, []],
        path: %r{^/foo$},
        target: %w(Foo index)
      )
    end
  end
end

def make_router
  router = Panda::Routing::Router.new
  router.draw do
    root "foo#index"
    get "/foo", to: "foo#index"
    get "/foo/new", to: "foo#new"
    get "/foo/:id", to: "foo#show"
    get "/foo/:id/edit", to: "foo#edit"
    post "/foo", to: "foo#create"
    put "/foo/:id", to: "foo#update"
    delete "/foo/:id", to: "foo#destroy"
  end
  router
end
