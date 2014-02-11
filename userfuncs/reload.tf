title:reload
runlevel:3
function:UserMethod
target:/reload/
separate_thread?:true
if_err_ignore?:show
method:st
  def reload
    if @admins.index(@current_tweet["user"]["screen_name"])
      self.read_tfs_inf
      self.activate
    end
  end
fn