module Wechat
  class Client
    class AccessToken
      ATTRIBUTES = %W(access_token expires_in errcode errmsg).freeze
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

    def get_access_token
      response = connection.get("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{appid}&secret=#{secret}")
      AccessToken.new MultiJson.load(response.body)
    end

    def get_auth_client
      AuthClient.new(appid, secret)
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
