title:imanokibun
runlevel:3
function:UserMethod
target:/今の気分は/
separate_thread?:true
if_err_ignore?:show
method:st
  def imanokibun
    if @id_list.index(@current_tweet["user"]["id"]) && @current_tweet["reply"]
      kanjyou=[]
			kanjyou=File.read("#{$base}/userfuncs/csv/kanjyou.csv").split(",")
			reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], kanjyou[rand(kanjyou.size)])
    end
  end
fn