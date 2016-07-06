require 'spec_helper'

RSpec.describe OAuth2::Strategy::AuthCode do

  subject do
    OAuth2::Strategy::AuthCode.new @client
  end

  def code
    "code"
  end

  def input_redirect_uri uri
    { redirect_uri: uri }
  end

  def usual_params
    {
        'grant_type' => 'authorization_code',
        'code' => code,
        'client_id' => nil,
        'client_secret' => nil
    }
  end

  describe "#get_token" do
    it "should work without redirect uri" do
      @client = instance_double('OAuth2::Client')
      expected_params = usual_params

      expect(@client).to receive(:id)
      expect(@client).to receive(:secret)
      expect(@client).to receive(:get_token).with(expected_params, {})

      subject.get_token(code)
    end

    it "should strip the query args from redirect uri" do
      @client = instance_double('OAuth2::Client')
      expected_params = {
          'redirect_uri' => 'http://my-service.com/some/path'
      }.merge(usual_params)

      expect(@client).to receive(:id)
      expect(@client).to receive(:secret)
      expect(@client).to receive(:get_token).with(expected_params, {})

      subject.get_token(code, { 'redirect_uri' => 'http://my-service.com/some/path?arg1=val1&arg2=val2' })
    end

    it "should leave uri intact without query args" do
      @client = instance_double('OAuth2::Client')
      expected_params = {
          'redirect_uri' => 'http://my-service.com/some/path'
      }.merge(usual_params)

      expect(@client).to receive(:id)
      expect(@client).to receive(:secret)
      expect(@client).to receive(:get_token).with(expected_params, {})

      subject.get_token(code, { 'redirect_uri' => 'http://my-service.com/some/path' })
    end

  end
end