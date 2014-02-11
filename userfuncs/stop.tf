title:stop
runlevel:3
function:UserMethod
target:/stop/
separate_thread?:true
if_err_ignore?:show
method:st
  def stop
    if @admins.index(@current_tweet["user"]["screen_name"]) && @current_tweet["reply"]
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], "管理者より停止コマンドが送信されたため停止します Date:#{getnow}")
      exit
    end
  end
fn