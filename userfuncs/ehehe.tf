title:ehehe
runlevel:3
function:UserMethod
target:/ありー|あり|ありがと/
separate_thread?:true
if_err_ignore?:show
method:st
  def ehehe
    if @id_list.index(@current_tweet["user"]["id"]) && @current_tweet["reply"]
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], "えへへっ　どういたしまして！")
    end
  end
fn