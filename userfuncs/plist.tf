title:plist
runlevel:3
function:UserMethod
target:/plist/
separate_thread?:true
if_err_ignore?:show
method:st
  def plist
    if @admins.index(@current_tweet["user"]["screen_name"])
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], @userfuncs.keys.join(","))
      p @userfuncs.keys.join(",")
    end
  end
fn