title:battle_dome_omikuji
runlevel:3
function:UserMethod
target:/(バトルドーム|バトルドォム).*(おみくじ)/
separate_thread?:true
if_err_ignore?:show
method:st
  def battle_dome_omikuji
    if @id_list.index(@current_tweet["user"]["id"]) && @current_tweet["reply"]
      array = ["バ","ト","ル","ド","ォ","ム"]
      tmp_str = array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)] + array[rand(6)]
      if tmp_str == "バトルドォム"
      result = "やったね！ バトルドォムになったよ！ おめでとー！"
      else
        result = "(´・ω・｀)しょぼーん 残念！ バトルドォムにならなかったよ また遊んでね！"
      end

      reply_str = "バトルドオムおみくじ 結果:【#{tmp_str}】 #{result} #バトルドォム"

      reply(@current_tweet["id_str"], @current_tweet["user"]["screen_name"], reply_str)
    end
  end
fn