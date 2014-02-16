title:getweather
runlevel:3
function:UserMethod
target:/天気/
separate_thread?:true
if_err_ignore?:show
method:st
  def getweather
    tweet = @current_tweet["text"]
    
    type = parse_reply(tweet)
    type = 1 if type == 4
    
    tmp = get_weather(tweet, type)
    if tmp == 5
      str = "地名が登録されてないよ！"
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], str)
      return nil
    end
    
    case type
      when 1,2
        make_str = "#{tmp[0]}の#{tmp[1]}の天気は#{tmp[2]}で 最高気温(℃)/最低気温(℃)は#{tmp[3]}です！"
        reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], make_str)
      when 3
        strs_size = tmp[0]
        loc = tmp[1]
        array = 0
        tmp2 = ""
        (strs_size).times{|i|
          break if array >= 7
          tmp2+="#{tmp[2][i][1]}の天気は#{tmp[2][i][2]}で 最高気温(℃)/最低気温(℃)#{tmp[2][i][3]}\n"
          array+=1
        }
        arrays=[[tmp2.split("\n")[0],tmp2.split("\n")[1],tmp2.split("\n")[2],tmp2.split("\n")[3]],[tmp2.split("\n")[4],tmp2.split("\n")[5],tmp2.split("\n")[6]]]
        ["#{loc}の週間天気(1/4)\n#{arrays[0][0]}\n#{arrays[0][1]}"," (2/4)\n#{arrays[0][2]}\n#{arrays[0][3]}\n(続く)", "(3/4)\n #{arrays[1][0]}\n#{arrays[1][1]}\n", "(4/4)\n#{arrays[1][2]}"].each{|str|
          reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], str)
        }
    end
  end
fn