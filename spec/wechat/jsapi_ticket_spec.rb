require File.expand_path("../../spec_helper", __FILE__)

describe 'jsapi ticket' do
  it 'gets ticket by access token' do
    body = %Q({"errcode":0,"errmsg":"ok","ticket":"bxLdikRXVbTPdHSM05e5u5sUoXNKd8-41ZO3MhKoyN5OfkWITDGgnr2fwJ0m9E8NYzWKVZvdVtaUgWvsdshFKA","expires_in":7200})

    stub_request(:get, "https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=ACCESS_TOKEN&type=jsapi").to_return(body: body)

    jsapi = Wechat::JsApi.new

    ticket = jsapi.get_ticket("ACCESS_TOKEN")

    expect(ticket).not_to be_nil
    expect(ticket.errcode).to eq(0)
    expect(ticket.errmsg).to eq("ok")
    expect(ticket.ticket).to eq("bxLdikRXVbTPdHSM05e5u5sUoXNKd8-41ZO3MhKoyN5OfkWITDGgnr2fwJ0m9E8NYzWKVZvdVtaUgWvsdshFKA")
    expect(ticket.expires_in).to eq(7200)
  end

  it "signs params with ticket" do
    ticket = "sM4AOVdWfPE4DxkXGEs8VMCPGGVi4C3VM0P37wVUCFvkVAy_90u5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcHKP7qg"
    jsapi = Wechat::JsApi.new

    signature = jsapi.sign(ticket, "Wm3WZYTPz0wzccnW", "1414587457", "http://mp.weixin.qq.com")

    expect(signature).to eq("f4d90daf4b3bca3078ab155816175ba34c443a7b")
  end

  it 'gets config' do
    ticket = "sM4AOVdWfPE4DxkXGEs8VMCPGGVi4C3VM0P37wVUCFvkVAy_90u5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcHKP7qg"
    jsapi = Wechat::JsApi.new

    allow(Time).to receive(:now).and_return(Time.new(2010,1,1, 11, 00, 00, "+00:00"))
    allow(SecureRandom).to receive(:hex).and_return("63828a411458c5455a4c")

    config = jsapi.get_config(ticket, "http://wx.qq.com", "APPID", ["previewImage"])

    expect(MultiJson.encode(config)).to eq(%Q({"appId":"APPID","timestamp":1262343600,"signature":"bac3e183806b8e69743c8583221fd7712dd93175","jsApiList":["previewImage"]}))
    end
end
