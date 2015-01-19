module Wechat
  class JsApi
    class Ticket
      ATTRIBUTES = %W(errcode errmsg ticket expires_in).freeze
      attr_reader *ATTRIBUTES

      def initialize(options = {}) 
        ATTRIBUTES.each do |name|
          instance_variable_set("@#{name}", options[name])
        end 
      end 
    end 

    def get_ticket(access_token)
      response = connection.get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{access_token}&type=jsapi")
      Ticket.new MultiJson.load(response.body)
    end 

    def sign(jsapi_ticket, noncestr, timestamp, url)
      params = {
        noncestr: noncestr,
        timestamp: timestamp,
        jsapi_ticket: jsapi_ticket,
        url: url
      }

      text = params.keys.sort.map {|key| "#{key}=#{params[key]}"}.join('&')
      
      Digest::SHA1.hexdigest(text)
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