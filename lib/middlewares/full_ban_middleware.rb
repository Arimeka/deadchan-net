class FullBanMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    if !(request.path =~ /(lodge)|(assets)/) && ip_banned?(request.ip)
      [403, {"Content-Type" => "text/html; charset=UTF-8"}, [response_text]]
    else
      @app.call(env)
    end
  end

  private

    def ip_banned?(ip)
      return true if $redis.exists("bans:full:#{ip}")
      ::Settings.ip_blocks.split(',').each do |ips|
        net = IPAddr.new ips
        ip_addr = IPAddr.new ip
        return true if net.include? ip_addr
      end
      false
    end

    def response_text
      <<-TEXT
<!DOCTYPE html>
<html lang='jpn'>
<head>
  <title>#{::Settings.site_name} - Forbidden</title>
  <meta charset='utf-8'>
  <meta content='IE=edge, chrome=1' http-equiv='X-UA-Compatible'>
  <link href='http://fonts.googleapis.com/css?family=Noto+Sans' rel='stylesheet' type='text/css'>
</head>
<body>
<pre style="font-family: 'Noto Sans', sans-serif; font-size:  12pt;">
/　　/　　　　　/　　/
　/　　/　　//　　　/
　 ＿_,____ 　　/　　　/
／// |ヽヽ＼
^^^^.|^^^^^^
　　　ﾍ⌒ヽﾌ
　　( |´･ω･)
(((　（つ　　）
　　 しー-Ｊ
''" 'ﾞ''` 'ﾞ ﾞﾟ'　'''　''
</pre>
</body>
      TEXT
    end

end
