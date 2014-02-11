#encoding:utf-8
require "net/https"
require "oauth"
require "json"
# ==========================================================
#  A simple Twitter API Rapper Library.
#  Copyleft (C) 2013 -2014 alphaKAI http://alpha-kai-net.info
# GPL v3 LICENSE
# ==========================================================
class TwiLib
  def initalize_connection(consumer_keys)
      consumer_key = consumer_keys[0]
      consumer_secret = consumer_keys[1]
      access_token = consumer_keys[2]
      access_token_secret = consumer_keys[3]

      @consumer = OAuth::Consumer.new(
        consumer_key,
        consumer_secret,
        :site => "https://api.twitter.com/"
      )
      @access_token = OAuth::AccessToken.new(
        @consumer,
        access_token,
        access_token_secret
      )
  end
  def genurl(endpoint, param)
    tmp = []
    param.to_a.each{|par|
      tmp << par.join("=")
    }
    return endpoint + "?" + tmp.join("&")
  end
  def get(endpoint, param)
    begin
      return JSON.parse(@access_token.get(endpoint, param).body)
    rescue Exception => e
      return [:err, e]
    end
  end
  def post(endpoint, param)
    begin
      @access_token.post(endpoint, param)
    rescue Exception => e
      return [:err, e]
    end
  end
  def user_stream(&block)
    uri = URI.parse("https://userstream.twitter.com/1.1/user.json")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    https.start{|https|
      request = Net::HTTP::Get.new(uri.request_uri, 'Accept-Encoding' => 'identity')
      request.oauth!(https, @consumer, @access_token)
      buf = ""
      https.request(request){|response|
        response.read_body{|chunk|
          buf << chunk
          while(line = buf[/.*(\r\n)+/m])
            begin
              buf.sub!(line,"")
              line.strip!
              status = JSON.parse(line)
            rescue
              break
            end
            yield status
          end
        }
      }
    }
  end
end