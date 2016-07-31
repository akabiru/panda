require "panda/version"

module Panda
  class Application
    def call(env)
      [ 200, { "Content-Type" => "text/html" }, ["Panda"]]
    end
  end
end
