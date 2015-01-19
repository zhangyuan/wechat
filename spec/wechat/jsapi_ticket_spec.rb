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
end
