title:botweather
runlevel:3
function:UserMethod
separate_thread?:false
if_err_ignore:show
method:st
  require "net/http"
  require "nokogiri"
  require "uri"
  def parse_reply(reply)
    unless /天気/ =~ reply
      return "ERROR"
    end
    weather_type     = 0
    case reply
      when /今日/
        weather_type = 1
      when /明日/
        weather_type = 2
      when /週間/
        weather_type = 3
    else
      return 4
    end
    return weather_type
  end
    
  def get_weather(reply, weather_type)
    return "ERROR" unless (1..3).include?(weather_type)
    return nil unless @current_tweet["reply"]

    pref2num     = Hash.new
    num2pref     = Hash.new
    pref_cap2num = Hash.new
    num2pref_cap = Hash.new

    doc = Nokogiri::HTML(open("#{$base}/userfuncs/bot_weather/pref.xml"))
    doc.xpath("//pref2num/prefs").each{|node|
      pref2num[node.xpath("name").text] = num  = node.xpath("num").text
    }
    doc.xpath("//num2pref/prefs").each{|node|
      num2pref[node.xpath("num").text] = node.xpath("name").text
    }
    doc.xpath("//pref_cap2num/prefs").each{|node|
      pref_cap2num[node.xpath("name").text] = node.xpath("num").text
    }
    doc.xpath("//num2pref_cap/prefs").each{|node|
      num2pref_cap[node.xpath("num").text] = node.xpath("name").text
    }

    place        = ""
    place2       = ""
    place_str    = ""
    place_str2   = ""
    return_array = []
    exist_check  = false

    pref2num.each{|now, hash|
      if reply.include?(now)
        exist_check = true
        place_str   = now
        place       = hash
      end
    }
    pref_cap2num.each{|now, hash|
      if reply.include?(now)
        place_str2=now
        place2=hash
      end
    }

    return if exist_check == false
    return "ERROR2" if place == nil

    case weather_type
      when 1
        weth     = ""
        count_wh = 0
        xml_doc  = get_xml("pref_#{place}")
        xml_doc.xpath("//title").each{|node|
          weth = node.text if count_wh == 2
          break if count_wh == 2
          count_wh += 1
        }
        tmp = weth.split
        
        tmp[0] =~ /\(.*\)/
        tmp[0] = $&.gsub(/(\(|\))/, "")
        return_array = tmp
      when 2
        weth     = ""
        count_wh = 0
        xml_doc  = get_xml("city_#{place2}")
        xml_doc.xpath("//title").each{|node|
          weth = node.text if count_wh == 4
          break if count_wh == 4
          count_wh += 1
        }
        tmp = weth.split
        tmp.unshift(num2pref_cap[place2])
        return_array = tmp
      when 3
        xml_doc  = get_xml("city_#{place2}")
        count_wh = 0
        array    = 0
        node2    = []
        strs     = []
        weth     = ""
        xml_doc.xpath("//title").each{|node|
          node2 << node.text if array > 1
          array += 1
        }

        strs << node2[0].to_s + node2[1].to_s << node2[2].to_s + node2[3].to_s << node2[4].to_s + node2[5].to_s << node2[6].to_s + node2[7].to_s << node2[8].to_s + node2[9].to_s << node2[10].to_s + node2[11].to_s << node2[12].to_s + node2[13].to_s << node2[14].to_s + node2[15].to_s << node2[16].to_s + node2[17].to_s << node2[18].to_s + node2[19].to_s << node2[20].to_s + node2[21].to_s << node2[22].to_s + node2[23].to_s

        array_tmp = []
        strs.each{|weth2|
          break if weth2.empty?
          tmp = weth2.split
          tmp.unshift(num2pref_cap[place2])
          array_tmp << tmp
        }

        array_tmp2  = []
        array_tmp2 << strs.size << num2pref_cap[place2] << array_tmp
        return_array = array_tmp2
    end
    return return_array
  end

  def get_xml(parm)
    url = URI.parse("http://tenki.jp/")
    res = Net::HTTP.start(url.host, url.port){|http|
      http.get("/component/static_api/rss/forecast/#{parm}.xml")
    }
    xml_doc = Nokogiri.XML(res.body)
  end
fn