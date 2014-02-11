title:kaigan
runlevel:3
function:UserMethod
target:/開眼/
separate_thread?:true
if_err_ignore?:show
method:st
  def kaigan
    if @id_list.index(@current_tweet["user"]["id"]) && @current_tweet["reply"]
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], "( ✹‿✹ )開眼 だァーーーーーーーーーーー！！！！！！！！！（ﾄｩﾙﾛﾛﾃｯﾃﾚｰｗｗｗﾃﾚﾃｯﾃﾃｗｗｗﾃﾃｰｗｗｗ）ｗｗｗﾄｺｽﾞﾝﾄｺﾄｺｼﾞｮﾝｗｗｗｽﾞｽﾞﾝｗｗ（ﾃﾃﾛﾘﾄﾃｯﾃﾛﾃﾃｰｗ")
    end
  end
fn