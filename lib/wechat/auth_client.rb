require "cgi"

module Wechat
  class AuthClient
    class AccessToken
      ATTRIBUTES = %w(access_token expires_in refresh_token openid scope errcode errmsg).freeze
      attr_reader *ATTRIBUTES

      def initialize(options = {})
        ATTRIBUTES.each do |name|
          instance_variable_set("@#{name}", options[name])
        end
      end
    end

    attr_reader :appid, :secret

    def initialize(appid, secret)
      @appid, @secret = appid, secret
    end

    def authorize_url(redirect_uri, state, options = {})
      scope = options[:scope] ||= "snsapi_base"
      "https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{appid}&redirect_uri=#{CGI.escape redirect_uri}&response_type=code&scope=#{scope}&state=#{state}#wechat_redirect" 
    end

    def get_token(code)
      response = connection.get("https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{appid}&secret=#{secret}&code=#{code}&grant_type=authorization_code")
      access_token = AccessToken.new MultiJson.load(response.body)
    end

    def connection
      @connection ||= begin
        conn = Faraday.new do |faraday|
          faraday.adapter  Faraday.default_adapter
        end 
      end
    end
  end
end
