# frozen-string-literal: true

require_relative 'display'
require_relative 'player'

# Class Game will hold logic for a functional connect-four game
class Game
  include Display

  attr_accessor :board, :current_player, :player_one, :player_two

  def initialize
    @board = Array.new(7) { Array.new(6, '0') }
    create_players
    @current_player = @player_one
  end

  def start_game
    start_intro

    play_game
  end

  def play_game
    loop do
      print_board(@board)
      show_player_turn(@current_player)
      token = drop_token(choose_column)

      break if check_endgame(token)

      switch_player
    end
    print_board(@board)
    start_outro
  end

  def choose_column
    print 'Choose a column from 1 to 7: '
    choice = user_input
    if !choice.between?(0, 6)
      puts 'Choice is not between 1-7! Please try again.'
      choose_column
    elsif column_full?(choice)
      puts 'That column is full! Please try again.'
      choose_column
    else
      choice
    end
  end

  def user_input
    gets.chomp.to_i - 1
  end

  def drop_token(column)
    5.downto(0) do |row|
      next if @board[column][row] != '0'

      @board[column][row] = @current_player.token
      return [column, row]
    end
  end

  def column_full?(column)
    @board[column][0] != '0'
  end

  def board_full?
    @board.flatten.none?('0')
  end

  def create_players
    @player_one = Player.new('Player One', '1')
    @player_two = Player.new('Player Two', '2')
  end

  def switch_player
    @current_player = @current_player == @player_one ? @player_two : @player_one
  end

  def check_endgame(token)
    if horizontal_win?(token) || vertical_win?(token) || diagonal_up_win?(token) || diagonal_down_win?(token)
      puts "#{@current_player.name} wins!"
      true
    elsif board_full?
      puts "Board is full! It's a draw!"
      true
    else
      false
    end
  end

  def horizontal_win?(token)
    # find leftmost piece
    if @board[token[0] - 1][token[1]] == @current_player.token && (token[0] - 1) >= 0
      horizontal_win?([token[0] - 1, token[1]])
      # check if the logic will go out of bounds
      # ie. if the leftmost token is at column 7 theres no way its a row
    elsif (token[0] + 3) > 6
      false
    elsif @current_player.token == @board[token[0] + 1][token[1]] &&
          @current_player.token == @board[token[0] + 2][token[1]] &&
          @current_player.token == @board[token[0] + 3][token[1]]
      true
    else
      false
    end
  end

  def vertical_win?(token)
    # token is automatically assumed as highest piece
    # so there is no need to check for highest piece
    if (token[1] + 3) > 5
      false
    elsif @current_player.token == @board[token[0]][token[1] + 1] &&
          @current_player.token == @board[token[0]][token[1] + 2] &&
          @current_player.token == @board[token[0]][token[1] + 3]
      true
    else
      false
    end
  end

  def diagonal_up_win?(token)
    # find furthest left-down piece
    if @board[token[0] - 1][token[1] + 1] == @current_player.token &&
       (token[0] - 1) >= 0 && (token[1] + 1) <= 5
      diagonal_up_win?([token[0] - 1, token[1] + 1])
      # check if the logic will go out of bounds
    elsif (token[0] + 3) > 6 || (token[1] - 3) < 0
      false
    elsif @current_player.token == @board[token[0] + 1][token[1] - 1] &&
          @current_player.token == @board[token[0] + 2][token[1] - 2] &&
          @current_player.token == @board[token[0] + 3][token[1] - 3]
      true
    else
      false
    end
  end

  def diagonal_down_win?(token)
    # find furthest left-up piece
    if @board[token[0] - 1][token[1] - 1] == @current_player.token &&
       (token[0] - 1) >= 0 && (token[1] - 1) >= 0
      diagonal_down_win?([token[0] - 1, token[1] - 1])
      # check if the logic will go out of bounds
    elsif (token[0] + 3) > 6 || (token[1] + 3) > 5
      false
    elsif @current_player.token == @board[token[0] + 1][token[1] + 1] &&
          @current_player.token == @board[token[0] + 2][token[1] + 2] &&
          @current_player.token == @board[token[0] + 3][token[1] + 3]
      true
    else
      false
    end
  end
end
