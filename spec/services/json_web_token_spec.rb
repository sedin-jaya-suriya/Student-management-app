require 'rails_helper'

RSpec.describe JsonWebToken do
  describe ".encode" do
    it "encodes a payload into a token" do
      token = JsonWebToken.encode(user_id: 1)
      expect(token).not_to be_nil
      expect(token.split('.').length).to eq(3)
    end
  end

  describe ".decode" do
    it "decodes a valid token" do
      token = JsonWebToken.encode(user_id: 1)
      decoded = JsonWebToken.decode(token)
      expect(decoded[:user_id]).to eq(1)
    end

    it "returns nil for an invalid token" do
      expect(JsonWebToken.decode("invalid_token")).to be_nil
    end

    it "returns nil for an expired token" do
      token = JsonWebToken.encode({ user_id: 1 }, 1.second.ago)
      expect(JsonWebToken.decode(token)).to be_nil
    end
  end
end
