# frozen-string-literal: true

require_relative '../lib/game'

describe Game do
  subject(:game) { described_class.new }
  # test choosing columns to drop tokens into
  describe '#choose_column' do
    it 'will return 6 as the column choice made' do
      allow(game).to receive(:user_input).and_return(6)
      result = game.choose_column
      expect(result).to eq(6)
    end
  end
  # test dropping tokens into the board
  describe '#drop_token' do
    context 'when the player is player_one' do
      it 'will drop a token in 6th column and set board[5][5] to 1' do
        column = 6 - 1
        game.drop_token(column)
        expect(game.board[5][5]).to eq('1')
      end
      it 'will drop a token in the 4th column and return [3, 5]' do
        column = 4 - 1
        result = game.drop_token(column)
        expect(result).to eq([3, 5])
      end
    end
    context 'when the player is player_two' do
      it 'will drop 6 tokens in the 1st column and set board[0][0] to 2' do
      end
    end
  end
  # test if column is full
  describe '#column_full?' do
    context 'when the column is not full' do
      it 'will return false' do
        result = game.column_full?(0)
        expect(result).to be false
      end
    end
    context 'when the column is full' do
      before do
        6.times { game.drop_token(0) }
      end
      it 'will return false' do
        result = game.column_full?(0)
        expect(result).to be true
      end
    end
  end
  # test if board is full
  describe '#board_full?' do
    context 'when the board is not full' do
      it 'will return false' do
        result = game.board_full?
        expect(result).to be false
      end
    end
    context 'when the board is full' do
      before do
        full_board = Array.new(7) { Array.new(6, '1') }
        game.board = full_board
      end
      it 'will return true' do
        result = game.board_full?
        expect(result).to be true
      end
    end
  end
  # test creating players
  describe '#create_players' do
    before do
      game.create_players
    end
    it 'will set player_one name to Player One' do
      expect(game.player_one.name).to eq('Player One')
    end

    it 'will set player_one token to 1' do
      expect(game.player_one.token).to eq('1')
    end
    it 'will set player_one name to Player Two' do
      expect(game.player_two.name).to eq('Player Two')
    end

    it 'will set player_one token to 2' do
      expect(game.player_two.token).to eq('2')
    end
  end
  # test playing switching turns
  describe '#switch_player' do
    before(:each) do
      game.player_one = 'Joe'
      game.player_two = 'Jan'
      game.current_player = game.player_one
    end
    it 'will switch from player_one to player_two' do
      result = game.switch_player
      expect(result).to eq(game.player_two)
    end

    it 'will switch from player_two to player_one' do
      game.switch_player
      result = game.switch_player
      expect(result).to eq(game.player_one)
    end
  end
  # test horizontal win logic
  describe '#horizontal_win?' do
    context 'when player_one has dropped a token into column 2 after dropping in 1, 3, and 4' do
      before do
        game.drop_token(0)
        game.drop_token(2)
        game.drop_token(3)
      end
      it 'will return true' do
        token = game.drop_token(1)
        result = game.horizontal_win?(token)
        expect(result).to be true
      end
    end
    context 'when the edges have pieces' do
      before do
        game.drop_token(0)
        game.drop_token(5)
        game.drop_token(6)
      end
      it 'will return false' do
        token = game.drop_token(1)
        result = game.horizontal_win?(token)
        expect(result).to be false
      end
    end
    context 'when there is no horizontal win' do
      before do
        game.drop_token(5)
      end
      it 'will return false' do
        token = game.drop_token(6)
        result = game.horizontal_win?(token)
        expect(result).to be false
      end
    end
  end
  # test vertical win logic
  describe '#vertical_win?' do
    context 'when player_one has dropped a token into column 2 three times prior' do
      before do
        game.drop_token(1)
        game.drop_token(1)
        game.drop_token(1)
      end
      it 'will return true' do
        token = game.drop_token(1)
        result = game.vertical_win?(token)
        expect(result).to be true
      end
    end
    context 'when there is no vertical win' do
      before do
        game.drop_token(1)
      end
      it 'will return false' do
        token = game.drop_token(1)
        result = game.vertical_win?(token)
        expect(result).to be false
      end
    end
  end
  # test diagonal up win logic
  describe '#diagonal_up_win?' do
    context 'when player_one has dropped a token into column 2 to create a diagonal' do
      before do
        game.drop_token(0)
        game.drop_token(1)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(3)
        game.drop_token(3)
        game.drop_token(3)
        game.drop_token(3)
      end
      it 'will return true' do
        token = game.drop_token(1)
        result = game.diagonal_up_win?(token)
        expect(result).to be true
      end
    end
    context 'when there is no diagonal up win' do
      before do
        game.drop_token(4)
        game.drop_token(5)
      end
      it 'will return false' do
        token = game.drop_token(5)
        result = game.diagonal_up_win?(token)
        expect(result).to be false
      end
    end
  end
  # test diagonal down win logic
  describe '#diagonal_down_win?' do
    context 'when player_one has dropped a token into column 2 to create a diagonal' do
      before do
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(3)
        game.drop_token(3)
        game.drop_token(4)
        game.drop_token(4)
        game.drop_token(5)
      end
      it 'will return true' do
        token = game.drop_token(3)
        result = game.diagonal_down_win?(token)
        expect(result).to be true
      end
    end
    context 'when there is no diagonal down win' do
      before do
        game.drop_token(5)
        game.drop_token(5)
      end
      it 'will return false' do
        token = game.drop_token(4)
        result = game.diagonal_down_win?(token)
        expect(result).to be false
      end
    end
  end
  # test endgame logic
  describe '#check_endgame' do
    context 'a horizontal row has been made' do
      before do
        game.drop_token(0)
        game.drop_token(2)
        game.drop_token(3)
      end
      it 'will return true' do
        token = game.drop_token(1)
        result = game.check_endgame(token)

        expect(result).to be true
      end
    end
    context 'a vertical column has been made' do
      before do
        game.drop_token(1)
        game.drop_token(1)
        game.drop_token(1)
      end
      it 'will return true' do
        token = game.drop_token(1)
        result = game.check_endgame(token)

        expect(result).to be true
      end
    end
    context 'when a rising diagonal row has been made' do
      before do
        game.drop_token(0)
        game.drop_token(1)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(3)
        game.drop_token(3)
        game.drop_token(3)
        game.drop_token(3)
      end
      it 'will return true' do
        token = game.drop_token(1)
        result = game.check_endgame(token)

        expect(result).to be true
      end
    end
    context 'when a falling diagonal row has been made' do
      before do
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(2)
        game.drop_token(3)
        game.drop_token(3)
        game.drop_token(4)
        game.drop_token(4)
        game.drop_token(5)
      end
      it 'will return true' do
        token = game.drop_token(3)
        result = game.check_endgame(token)

        expect(result).to be true
      end
    end
  end
end
