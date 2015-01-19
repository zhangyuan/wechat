require File.expand_path("../../spec_helper", __FILE__)

RSpec.describe Wechat::AuthClient do
  it 'should generate authorize_url' do
    client = Wechat::AuthClient.new("theappid", "thesecret")
    authorize_url = client.authorize_url("http://example.com/wechat", "999")
    expected_url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=theappid&redirect_uri=http%3A%2F%2Fexample.com%2Fwechat&response_type=code&scope=snsapi_base&state=999#wechat_redirect" 
    expect(authorize_url).to eq(expected_url)
  end

  context "correct params" do
    it 'should get token' do
      client = Wechat::AuthClient.new("theappid", "thesecret")
      body = %q(
      {
        "access_token":"ACCESS_TOKEN",
        "expires_in":7200,
        "refresh_token":"REFRESH_TOKEN",
        "openid":"OPENID",
        "scope":"SCOPE"
      }
      )
      stub_request(:get, "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{client.appid}&secret=#{client.secret}&code=thecode&grant_type=authorization_code").to_return(body: body)

      access_token = client.get_token("thecode")
      
      expect(access_token.access_token).to eq("ACCESS_TOKEN")
      expect(access_token.expires_in).to eq(7200)
      expect(access_token.refresh_token).to eq("REFRESH_TOKEN")
      expect(access_token.openid).to eq("OPENID")
      expect(access_token.scope).to eq("SCOPE")
    end
  end

  context "invalid params" do
    it 'should get error' do
      client = Wechat::AuthClient.new("theappid", "thesecret")
      body = %q(
      {
        "errcode": 40029,
        "errmsg": "invalid code"
      }
      )
      stub_request(:get, "https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{client.appid}&secret=#{client.secret}&code=thecode&grant_type=authorization_code").to_return(body: body)

      access_token = client.get_token("thecode")
      
      expect(access_token.errcode).to eq(40029)
      expect(access_token.errmsg).to eq("invalid code")
    end
  end
end
