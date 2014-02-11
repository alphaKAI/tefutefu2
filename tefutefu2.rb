#encoding:utf-8
require_relative "./lib/twilib"
require_relative "./tefutefu_engine"
require "nokogiri"

class TefuTefu2
  attr_accessor :consumer_key, :consumer_secret,
                :access_token, :access_token_secret,
                :appname, :version, :bot_id, :bot_hn, :admins

  def initialize
    unless File.exist?("./resource/setting.xml")
      "Error : Not Found Setting File at \'./resource/setting.xml\'"
    end
    setting  = Nokogiri::HTML(open("./resource/setting.xml"))
    @oaut_hash = Hash.new
    setting.xpath('//*[@class="oauth"]').each{|elem|
      case(elem.name)
        when /consumer_key/
          @oaut_hash[:consumer_key]        = elem.children.text
          self.consumer_key                = elem.children.text
        when /consumer_secret/
          @oaut_hash[:consumer_secret]     = elem.children.text
          self.consumer_secret             = elem.children.text
        when /access_token$/
          @oaut_hash[:access_token]        = elem.children.text
          self.access_token                = elem.children.text
        when /access_token_secret/
          @oaut_hash[:access_token_secret] = elem.children.text
          self.access_token_secret         = elem.children.text
      end
    } 
    setting.xpath('//*').each{|elem|
      case(elem.name)
        when /appname/
          self.appname = elem.children.text
        when /version/
          self.version = elem.children.text
        when /bot_id/ 
          self.bot_id = elem.children.text
        when /bot_hn/
          self.bot_hn = elem.children.text
      end
    }
    @admins = []
    setting.xpath('//admins/*').each{|elem|
      @admins << elem.children.text if elem.name =~ /admin/
    }
    @tl = TwiLib.new
    @tl.initalize_connection(@oaut_hash.values)

    @te = TefuEngine.new
    @te.twilib_instance = @tl
    @te.admins  = @admins
    @te.version = @version
    @te.bot_id  = @bot_id
    @te.bot_hn  = @bot_hn
    puts "admins:#{@te.admins}"
    end

  def boot
    @te.read_tfs_inf
    @te.activate
    @te.id_list = @tl.get("/1.1/followers/ids.json", {"screen_name" => "tefutefu_tyou"})["ids"]
    #@te.update("てふてふ2が起動しました version:#{self.version} Date:#{@te.getnow}")
    @tl.user_stream{|status_json|
        puts status_json["text"]
        @te.parser(status_json)
    }
  end
end