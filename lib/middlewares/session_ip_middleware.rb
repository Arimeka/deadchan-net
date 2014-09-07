class SessionIpMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)
    session = request.session

    if session[:ip].present?
      if session[:ip] != request.ip
        session.keys.each { |key| session.delete key }
      end
    else
      session[:ip] = request.ip
    end

    @app.call(env)
  end

end
