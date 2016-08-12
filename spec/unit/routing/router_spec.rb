require "spec_helper"

RSpec.describe Panda::Routing::Router do
  let(:router) { Panda::Routing::Router.new }

  describe "initialize" do
    it "initializes @endpoints hash" do
      expect(router.endpoints).to be_a Hash
    end
  end

  describe "#draw" do
    it "evalutes object in its context" do
      router.draw { get "/foo", to: "foo#bar" }

      expect(router.endpoints["GET"]).not_to be_nil
    end
  end

  describe "#get" do
    it "sets endpoint 'GET'" do
      router.get "/bar", to: "foo#bar"

      expect(router.endpoints["GET"]).
        to include(
          pattern: [%r{^/bar$}, []], path: %r{^/bar$}, target: %w(Foo bar)
        )
    end
  end

  describe "#post" do
    it "sets endpoint 'POST'" do
      router.post "/bar", to: "bar#create"

      expect(router.endpoints["POST"]).
        to include(
          pattern: [%r{^/bar$}, []],
          path: %r{^/bar$},
          target: %w(Bar create)
        )
    end
  end

  describe "#delete" do
    it "sets endpoint 'DELETE'" do
      router.delete "/bar/:id", to: "bar#destroy"

      expect(router.endpoints["DELETE"]).to include(
        pattern: [%r{^/bar/(?<id>\w+)$}, ["id"]],
        path: %r{^/bar/:id$},
        target: %w(Bar destroy)
      )
    end
  end

  describe "#put" do
    it "sets endpoint 'PUT'" do
      router.put "/bar/:id", to: "bar#update"

      expect(router.endpoints["PUT"]).to include(
        pattern: [%r{^/bar/(?<id>\w+)$}, ["id"]],
        path: %r{^/bar/:id$},
        target: %w(Bar update)
      )
    end
  end

  describe "#patch" do
    it "sets endpoint 'PATCH'" do
      router.patch "/bar/:id", to: "bar#update"

      expect(router.endpoints["PATCH"]).to include(
        pattern: [%r{^/bar/(?<id>\w+)$}, ["id"]],
        path: %r{^/bar/:id$},
        target: %w(Bar update)
      )
    end
  end

  describe "#root" do
    it "sets root endpoint 'GET'" do
      router.root "bar#index"

      expect(router.endpoints["GET"]).to include(
        pattern: [%r{^/$}, []], path: %r{^/$}, target: %w(Bar index)
      )
    end
  end
end
