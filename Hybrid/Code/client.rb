require 'drb'
require 'colorize'
class Client
  include DRbUndumped

  def initialize(server,player)
    DRb.start_service("druby://localhost:0")
    @server, @player = server, player
    log("Login on server at #{server}",1)

  end

  def run
     @server.login(self)

  end

  def log(message,code)
    time = Time.now
    if code.eql? 0
      puts "[Server Info] #{message} at #{time.strftime("%a %d, %b %Y")}".green
    elsif code.eql? 1
      puts "#{message} at #{time.strftime("%a %d, %b %Y")}".blue
    end

  end

  def get_name
    @player
  end

  def set_opponent(user, player,turn)
    @num_player = player
    @opponent = user

    @opponent.log("Hello I'm #{@player}",1)
    @opponent.log("neeeeaaa",1)
    juego(turn,0)
  end

  def juego(turn,move)
     if move < 9
       if turn.eql? 1 and @num_player.eql? 1
         puts "escriba el movimiento"
         movement =  $stdin.gets.chomp
         @opponent.log("el oponente escribio #{movement}, jugada numero #{move}",1)
         @opponent.juego(2,move+1)
       elsif turn.eql? 2 and @num_player.eql? 2
         puts "escriba el movimiento"
         movement =  $stdin.gets.chomp
         @opponent.log("el oponente escribio #{movement}, jugada numero #{move}",1)
         @opponent.juego(1,move+1)
       end
     end
  end

  def mensaje(mess)
    puts(mess)
  end

end


if ARGV.length.eql? 2
  server_uri = 'druby://localhost:' +  ARGV[1]
else
  server_uri = 'druby://localhost:4000'
end
server = DRbObject.new_with_uri(server_uri)
client = Client.new(server,ARGV[0])
client.run
DRb.thread.join
