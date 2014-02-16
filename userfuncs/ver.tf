title:ver
runlevel:3
function:UserMethod
target:/ver/
separate_thread?:true
if_err_ignore?:show
method:st
  def ver
    if @admins.index(@current_tweet["user"]["screen_name"]) && @current_tweet["reply"]
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"],"てふてふのばーじょん#{@version}")
    end
  end
fn