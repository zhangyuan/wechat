require File.expand_path("../../spec_helper", __FILE__)

describe "client" do
  describe "access token" do
    it "get access token" do
      client = SimpleWechat::Client.new("APPID", "APPSECRET")

      body = %Q({"access_token":"ACCESS_TOKEN", "expires_in":7200})
      stub_request(:get, "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET").to_return(body: body)

      access_token = client.get_access_token

      expect(access_token).not_to be_nil
      expect(access_token.access_token).to eq("ACCESS_TOKEN")
      expect(access_token.expires_in).to eq(7200)
    end

    it "get error code and msg if get error from response" do
      client = SimpleWechat::Client.new("APPID", "APPSECRET")

      body = %Q({"errcode":40013,"errmsg":"invalid appid"})
      stub_request(:get, "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=APPID&secret=APPSECRET").to_return(body: body)

      access_token = client.get_access_token

      expect(access_token).not_to be_nil
      expect(access_token.access_token).to be_nil
      expect(access_token.errcode).to eq(40013)
      expect(access_token.errmsg).to eq("invalid appid")
    end
  end
end
