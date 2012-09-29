require 'drb'
require 'colorize'
class Server
  include DRbUndumped

  def initialize(port = 4000)
    puts port
    DRb.start_service("druby://localhost:#{port}", self)
    log "Server started: #{DRb.uri}"
    @users, @match = {},[]
  end

  def log(message)
    time = Time.now
    puts "#{message} at #{time.strftime("%a %d, %b %Y")}".green
  end

  def login(user)
    user_name = user.get_name
    if @users.include? user_name
        user.log("The name is already taken",0)
    else
        user.log("Welcome to the best tic-tac-toc",0)
        @users[user_name] = user
        match(user)
    end
  end

  def match(user)
    if @match.count.eql? 1
      @match[1] = user
      user.log("The match is going to begin",0)
      @match[0].set_opponent(user)
      user.set_opponent(@match[0])
    else
      @match[0] = user
      user.log("Waiting for the opponent",0)
    end
  end



end

server = Server.new()
DRb.thread.join()