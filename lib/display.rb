# frozen-string-literal: true

# Module Display for presenting information into the command line
module Display
  # show introductory message
  def start_intro
    intro = <<-MESSAGE

    Hello and welcome to Connect Four! A game where 2 players take turns to drop their tokens and try to get four in a row!

    MESSAGE
    puts intro
  end

  def show_player_turn(player)
    puts "It is #{player.name}'s turn!"
  end

  def print_board(board)
    puts '1 2 3 4 5 6 7'
    puts '-------------'
    6.times do |y|
      7.times do |x|
        print "#{board[x][y]} "
      end
      puts
    end
    puts '-------------'
    puts '1 2 3 4 5 6 7'
  end

  def start_outro
    puts 'See you next time! Goodbye~'
  end
end
