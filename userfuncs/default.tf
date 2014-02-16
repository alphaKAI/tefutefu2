title:default
runlevel:4
function:UserMethod
target:/.*/
separate_thread?:true
if_err_ignore?:show
method:st
  def default
    if @id_list.index(@current_tweet["user"]["id"])
      favorite(@current_tweet["id_str"])
      
      words = []
      words = File.read("#{$base}/userfuncs/csv/words.csv").split(",")

      itaden = ["結婚しろ","ﾁｯｽｗｗｗｗｗｗｗｗｗｗ","あっオカン来たから切るわ","今あなたの後ろにいるの","なんでもねぇよｗｗｗｗｗｗｗｗｗｗｗｗｗ","間違えましたｗｗｗｗｗｗｗｗ","めしなう", "{USERNAME}ですか"*3,"☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎☎","やったｗｗｗｗｗｗｗｗｗｗイタ電成功ｗｗｗｗｗｗｗ"]
      make_str=words[rand(words.size)]
      if make_str == "イタ電"
        make_str = ""
        make_str = "┗(^o^)┛イタ電するぞぉぉぉｗｗ( ^o^)☎┐もしもしｗｗｗｗｗｗ{USERNAME}ですかｗｗｗｗｗｗｗｗ#{itaden[rand(itaden.size)]}( ^o^)Г☎ﾁﾝｯ"
      end
      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], replace_string({"USERNAME" => @current_tweet["user"]["name"]}, make_str))
    end
  end
fn