require 'spec_helper'

describe StateTransition::DeepCopy do
  using StateTransition::DeepCopy

  describe "Array#deep_copy" do
    before(:each) do
      @orig_arr = [1,2,3, [4,5,6, [7,8,9]]]
    end

    it "double stair array" do
      copy = @orig_arr.deep_copy
      copy[-1][0] = 100
      expect(@orig_arr[-1][0]).not_to eq(copy[-1][0])
    end

    it "triple stair array" do
      copy = @orig_arr.deep_copy
      copy[-1][-1][-1] = 100
      expect(@orig_arr[-1][-1][-1]).not_to eq(copy[-1][-1][-1])
    end
  end

  describe "Hash#deep_copy" do
    before(:each) do
      @orig_hash = { hoge: "hoge", piyo: { fuga: "fuga" }}
    end

    it "single stair hash" do
      copy = @orig_hash.deep_copy
      copy[:hoge] = "Ruby"
      expect(@orig_hash[:hoge]).not_to eq(copy[:hoge])
    end

    it "double stair hash" do
      copy = @orig_hash.deep_copy
      copy[:piyo][:fuga] = "Ruby"
      expect(@orig_hash[:piyo][:fuga]).not_to eq(copy[:piyo][:fuga])
    end
  end
end
