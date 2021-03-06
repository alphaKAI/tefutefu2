#encoding:utf-8
# Parse User Tweet And Call Functions
class TefuEngine
  attr_accessor :twilib_instance, :userfuncs,
                :current_tweet, :id_list,
                :admins, :version, :bot_id, :bot_hn
  def initialize
    @userfuncs = Hash.new
    @files = Array.new
    @file_count = 0
    @file_count_t = 0
    @ii = 0
    @filename_t = nil
    @tmp = nil
  end

  def read_tfs_inf
    @file_count = dirf
    unless @file_count == @file_count_t
      @files = Array.new
      dirf(lambda{@files << @tmp if @tmp =~ /.*\.tf$/ }, lambda{return nil})
    end
    @files.each{|fn|
      puts "PLUGIN READ:#{fn.gsub(/((.*\/)+)|(\.tf)/, "")}"
      read_tfs(File.read(fn))
    }
    @file_count_t = @file_count
  end

  def read_tfs(tf_file_data, option = Hash.new)
    hash        = Hash.new
    func_status = false
    tf_file_data.split("\n").each{|line|
      next unless line =~ /.*\".*\".*/ if line =~ /.*\#.*$/

      if line =~ /.*\:.*/ && !func_status
        ary = line.split(":")
        t = false;t = true if ary[1] == "st"
        func_status = true if t
        ary[0].gsub!(/^(\s|\t)+/,"")
        hash[ary[0]] = ary[1] unless t
        next
      end
      if line =~ /fn$/
        func_status = false
        next
      end
      if func_status
        line.gsub!(/^(\s|\t)+/,"")
        hash["method"] = "#{hash["method"]};#{line}"
        hash["method"].gsub!(/^;/,"")
        next
      end
    }

    @userfuncs[hash["title"]] = hash if hash["title"]
    ["target", "ignore"].each{|search_for|
      replace_regexp_string(hash, search_for, {"BOTNAME_HN" => @bot_hn, "BOT_ID" => @bot_id})
    }

    return nil
  end

  def parser(status_json)
    self.read_tfs_inf
    self.activate
    defined_hash = {"USERNAME" => status_json["user"]["name"]} if status_json["text"]
    if status_json["event"]
      case(status_json["event"])
        when /follow/
          add_queue_of_follow(status_json["source"]["screen_name"])
        when /remove/
          add_queue_of_remove(status_json["source"]["screen_name"])
      end
    elsif status_json["text"]
      @current_tweet = status_json

      puts "USER:#{defined_hash["USERNAME"]}"
      if status_json["text"] =~ /^@#{@bot_id}/
        @current_tweet["reply"] = true
      else
        @current_tweet["reply"] = false
      end

      status = false
      @userfuncs.each{|name, function|
        next if name =~ /default/
        case(function["function"])
          when /Reply/
            if status_json["text"] =~ function["target"]
              if function["ignore"] && !(status_json["text"] =~ function["ignore"])
                puts "[INFO][ENGINE]:[Reply]"

                reply(status_json["id_str"], status_json["user"]["screen_name"], replace_string(defined_hash, function["string"]))
                status = true
              end
            end
          when /Favorite/
            if status_json["text"] =~ function["target"]
              puts "[INFO][ENGINE]:[Favorite]"
              favorite(status_json["id_str"])
              status = true
            end
          when /Follow/
            if status_json["text"] =~ function["target"]
              puts "[INFO][ENGINE]:[Follow]"
              follow(status_json["user"]["screen_name"])
              status = true
            end
          when /UserMethod/
            if status_json["text"] =~ function["target"]
              puts "[INFO][ENGINE]:[UserMethod:#{name}]"
              begin
                lunch_func(name)
                status = true
              rescue Exception => e
                puts "ERROR : [#{name}] => #{e}"
              end
            end
        end

        break if status && function["runlevel"].to_i >= 3
      }
      if !status && @current_tweet["reply"]
        begin
          puts "[INFO][ENGINE]:[Default]"
          eval("default") if default
        rescue Exception => e
          puts "ERROR : [#{name}] => #{e}"
        end
      end
    end
  end

  def lunch_func(func_name)
    uhash = @userfuncs[func_name]
    begin
      if (uhash["separate_thread?"] =~ /true/i ? true : false)
        do_as_separate_thread(lambda{ eval(func_name) })
      else
        eval(func_name)
      end

    rescue Exception => e
      puts "ERROR: #{e}" if uhash["if_err_ignore?"]
      if uhash["if_err_ignore?"] == "exit"
        puts "To be shutdown :: Error-function_name:#{func_name}"
        exit
      end
    end
  end

  def enable(title)
    eval(@userfuncs[title]["method"])
  end

  def disable(title)
    eval("undef #{title}")
  end

  def update(str)
    p twilib_instance.post("/1.1/statuses/update.json", {"status" => str}) unless $debug_
    debug_show("update", str) if $debug_
  end

  def getnow
    return Time.now.instance_eval{ "%s.%03d" % [strftime("%Y年%m月%d日%H時%M分%S秒"), (usec / 1000.0).round]}
  end

  def activate
    @userfuncs = sortsort(@userfuncs)
    @userfuncs.keys.each{|key|
      eval(@userfuncs[key]["method"]) if @userfuncs[key]["method"]
    }
  end

  def reload_tfs
    @file_count = dirf
    @files      = Array.new
    @userfuncs  = Hash.new

    dirf(lambda{ @files << @tmp if @tmp =~ /.*\.tf$/ }, lambda{ return nil })

    @files.each{|fn|
      puts "PLUGIN READ:#{fn.gsub(/((.*\/)+)|(\.tf)/, "")}"
      read_tfs(File.read(fn))
    }
    @file_count_t = @file_count
  end

  #========private==========
  private

    def dirf(lambda_val = lambda{ @i+=1 }, return_lambda = lambda{ return @i }, initalize_lambda = lambda{ @i=0 })
    @files = Array.new
    initalize_lambda.call
    Dir.glob("#{$base}/userfuncs/*").each{|filename|
      @tmp = filename
      lambda_val.call
    }
    return return_lambda.call
  end

  def sortsort(hash = @userfuncs)
    return Hash[hash.sort{|a ,b| hash[a[0]]["runlevel"] <=> hash[b[0]]["runlevel"] }]
  end

  def do_as_separate_thread(do_func, join_ = true)
    if join_
      Thread.new{ do_func.call }.join
    else
      Thread.new{ do_func.call }
    end
  end

  def favorite(tweet_id)
    twilib_instance.post("/1.1/favorites/create.json", {"id" => tweet_id}) unless $debug_
  end

  def reply(tweet_id, target_id, str)
    if @id_list.index(@current_tweet["user"]["id"])
      p twilib_instance.post("/1.1/statuses/update.json",
        {"status" => "@#{target_id} #{str}",
        "in_reply_to_status_id" => tweet_id}) unless $debug_
    end
    debug_show("Reply", str) if $debug_
  end

  def replace_string(dhash, string)
    r_string = nil
    change   = false
    dhash.each{|key, value|
      if string =~ /#{key}/
        r_string = string.gsub(/\{#{key}\}/, value)
        change   = true
      end
    }
    return r_string if change
    return string   unless change
  end

  def replace_regexp_string(hash, search_for, replace_hash)
    if hash[search_for]
      @userfuncs[hash["title"]][search_for] = replace_string(replace_hash, @userfuncs[hash["title"]][search_for])
      @userfuncs[hash["title"]][search_for] = Regexp.new(hash[search_for].gsub(/\//, ""))
    end
  end

  #Not Perfect : not recommend 
  def add_queue_of_follow(id)
    twilib_instance.post("/1.1/friendships/create.json", {"screen_name" => id})
    @id_list << id
  end

  def add_queue_of_remove(id)
    twilib_instance.post("/1.1/friendships/destroy.json", {"screen_name" => id})
    @id_list.delete(id)
  end

  def debug_show(method, str)
      puts "=================="
      puts "Method:#{method}"
      puts "String:#{str}"
  end
end