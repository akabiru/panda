require "spec_helper"

RSpec.describe Panda::Record::BaseHelper do
  it_behaves_like "a private method provider", :build_column_methods
  it_behaves_like "a private method provider", :column_names_with_constraints
  it_behaves_like "a private method provider", :parse_constraints
  it_behaves_like "a private method provider", :get_model_object
  it_behaves_like "a private method provider", :type
  it_behaves_like "a private method provider", :primary_key
  it_behaves_like "a private method provider", :nullable
end
