# frozen_string_literal: true

require "heapmap/registry"

RSpec.describe "scaffold" do
  it "loads the registry" do
    expect(Heapmap::VERSION).to eq("0.1.0")
  end
end
