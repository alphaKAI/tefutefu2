title:say
runlevel:3
function:UserMethod
target:/say/
separate_thread?:true
if_err_ignore?:show
method:st
  def say
    if @admins.index(@current_tweet["user"]["screen_name"]) && @current_tweet["reply"]
      update("管理者より:#{@current_tweet["text"].gsub(/^@.*say:/, "")}")
    end
  end
fn