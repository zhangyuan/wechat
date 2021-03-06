# SimpleWechat

[![Build Status](https://travis-ci.org/zhangyuan/wechat.svg)](https://travis-ci.org/zhangyuan/wechat)

[![Build Status](https://snap-ci.com/zhangyuan/wechat/branch/master/build_image)](https://snap-ci.com/zhangyuan/wechat/branch/master)

[![Code Climate](https://codeclimate.com/github/zhangyuan/wechat/badges/gpa.svg)](https://codeclimate.com/github/zhangyuan/wechat)

[![Test Coverage](https://codeclimate.com/github/zhangyuan/wechat/badges/coverage.svg)](https://codeclimate.com/github/zhangyuan/wechat/coverage)

Simple Wechat Api Wrapper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_wechat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_wechat

## Usage

### Fetch access token

```ruby
client = SimpleWechat::Client.new("APPID", "APPSECRET")
access_token = client.get_access_token  
# access_token and expires_in are wrapped in access_token.
```

### Fetch jsapi ticket

```ruby
jsapi = SimpleWechat::JsApi.new
ticket = jsapi.get_ticket("ACCESS_TOKEN")
# ticket, errcode, errmsg, expires_in are wrapped in ticket.
```

### Get jsapi config

```ruby
ticket = "sM4AOVdWfPE4DxkXGEs8VMCPGGVi4C3VM0P37wVUCFvkVAy_90u5h9nbSlYy3-Sl-HhTdfl2fzFy1AOcHKP7qg"
jsapi = SimpleWechat::JsApi.new
config = jsapi.get_config(ticket, "http://wx.qq.com", "APPID", ["previewImage"])
# now MultiJson.encode(config) can be passed into function wx.config() in javascript.
```

### OAuth

OAuth part is borrowed from `wechat-auth_client` ( https://github.com/zhangyuan/wechat-auth_client ).

> `REDIRECT_URL` should be configured in WeChat management system and route to callback action

```ruby
class SessionsController < ApplicationController
  def auth
    redirect_to auth_client.authorize_url(REDIRECT_URL, state)
  end

  def callback
    if state == params[:state]
      access_token = auth_client.get_token(params[:code])
      # do something with access_token. 
      # for example, call access_token.openid to get openid
    end
  end

  private

  def auth_client
    @auth_client ||= SimpleWechat::Client.new(APP_ID, APP_SECRET).get_auth_client
  end
  
  def state
    session[:state] ||= SecureRandom.hex(3)
  end
end
```

## Contributing

1. Fork it ( https://github.com/zhangyuan/wechat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
