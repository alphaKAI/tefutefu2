title:favoreyo
runlevel:3
function:UserMethod
target:/ふぁぼれよ/
separate_thread?:true
if_err_ignore?:show
method:st
  def favoreyo
    if @id_list.index(@current_tweet["user"]["id"]) && @current_tweet["reply"]
      favorite(@current_tweet["id_str"])
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], "ふぁぼったよ！ (´へωへ`*)　→　https://twitter.com/#{@current_tweet["user"]["screen_name"]}/status/#{@current_tweet["id_str"]}")
    end
  end
fn