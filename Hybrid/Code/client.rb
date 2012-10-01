require 'drb'
require 'colorize'
class Client
  include DRbUndumped

  def initialize(server,player)
    DRb.start_service("druby://localhost:0")
    @server, @player = server, player
    log("Login on server at #{server}",1)
    @board = [
        ["_","_","_"],
        ["_","_","_"],
        ["_","_","_"]
    ]
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
         position(movement,@num_player)
         @opponent.log("el oponente escribio #{movement}, jugada numero #{move}",1)
         @opponent.print_board(@board)
         @opponent.juego(2,move+1)

       elsif turn.eql? 2 and @num_player.eql? 2
         puts "escriba el movimiento"
         movement =  $stdin.gets.chomp
         position(movement,@num_player)
         @opponent.log("el oponente escribio #{movement}, jugada numero #{move}",1)
         @opponent.print_board(@board)
         @opponent.juego(1,move+1)

       end
     end
  end

  def print_board(board)
    puts "\n
               |          |
               |          |
          #{board[0][0]}    |    #{board[0][1]}     |    #{board[0][2]}
     __________|__________|__________
               |          |
          #{board[1][0]}    |    #{board[1][1]}     |    #{board[1][2]}
               |          |
     __________|__________|__________
               |          |
          #{board[2][0]}    |    #{board[2][1]}     |    #{board[2][2]}
               |          |
               |          |"

  end

  def position(move, player)
    letter = "X"
    exit_code = 0
    if player.eql? 2
      letter = "O"
    end

    p = case move
          when "1"
            [0,0]
          when "2"
            [0,1]
          when "3"
            [0,2]
          when "4"
            [1,0]
          when "5"
            [1,1]
          when "6"
            [1,2]
          when "7"
            [2,0]
          when "8"
            [2,1]
          when "9"
            [2,2]
          else
            exit_code = 1
        end
    if @board[p[0]][p[1]].eql? "_"
      @board[p[0]][p[1]] = letter
      #exit_code = check_winner(letter, player)
    else
      exit_code = 2
    end
    exit_code
  end

  def check_winner(letter, player)
    code = 0
    if @board[0][0] == @board[0][1] and @board[0][1] == @board[0][2] and @board[0][2] == letter
      code = 3
    elsif @board[1][0] == @board[1][1] and @board[1][1] == @board[1][2] and @board[1][2] == letter
      code = 3
    elsif @board[2][0] == @board[2][1] and @board[2][1] == @board[2][2] and @board[2][2] == letter
      code = 3
    elsif @board[0][0] == @board[1][0] and @board[1][0] == @board[2][0] and @board[2][0] == letter
      code = 3
    elsif @board[0][1] == @board[1][1] and @board[1][1] == @board[2][1] and @board[2][1] == letter
      code = 3
    elsif @board[0][2] == @board[1][2] and @board[1][2] == @board[2][2] and @board[2][2] == letter
      code = 3
    elsif @board[0][0] == @board[1][1] and @board[1][1] == @board[2][2] and @board[2][2] == letter
      code = 3
    elsif @board[0][2] == @board[1][1] and @board[1][1] == @board[2][0] and @board[2][0] == letter
      code = 3
    else
      puts "No winner yet."
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
