require 'spec_helper'

describe Board do
  let(:board) { FactoryGirl.create(:board) }

  subject { board }

  context 'respond and valid' do
    it { should respond_to(:title) }
    it { should respond_to(:abbr) }
    it { should respond_to(:placement_index) }
    it { should respond_to(:threads_number) }
    it { should respond_to(:is_threadable) }
    it { should respond_to(:is_published) }

    it { should respond_to(:treads) }

    it { should be_valid }
  end

  context 'not valid' do
    context 'without' do
      it 'title' do
        board.title = nil
        expect(board).to be_invalid
      end

      it 'abbr' do
        board.abbr = nil
        expect(board).to be_invalid
      end

      it 'placement_index' do
        board.placement_index = nil
        expect(board).to be_invalid
      end

      it 'threads_number' do
        board.threads_number = nil
        expect(board).to be_invalid
      end

      it 'is_threadable' do
        board.is_threadable = nil
        expect(board).to be_invalid
      end

      it 'is_published' do
        board.is_published = nil
        expect(board).to be_invalid
      end
    end

    context 'with too short' do
      it 'title' do
        board.title = Faker::Lorem.characters(1)
        expect(board).to be_invalid
      end
    end

    context 'with too long' do
      it 'title' do
        board.title = Faker::Lorem.characters(40)
        expect(board).to be_invalid
      end

      it 'abbr' do
        board.abbr = Faker::Lorem.characters(10)
        expect(board).to be_invalid
      end
    end

    it 'with not unique abbr' do
      new_board = FactoryGirl.build(:board, abbr: board.abbr)
      expect(new_board).to be_invalid
    end

    context 'with not integer' do
      it 'placement_index' do
        board.placement_index = 1.1
        expect(board).to be_invalid

        board.placement_index = 'foobar'
        expect(board).to be_invalid
      end

      it 'threads_number' do
        board.threads_number = 1.1
        expect(board).to be_invalid

        board.threads_number = 'foobar'
        expect(board).to be_invalid
      end
    end
  end

  it 'scope :published return only published boards' do
    new_board = FactoryGirl.create(:board, is_published: false)
    board
    expect(Board.published.to_a).to eq [board]
  end

  context 'check Settings.readonly first' do
    before(:each) do
      Settings.readonly = nil
    end
    after(:each) do
      Settings.readonly = nil
    end

    it 'call #is_threadable' do
      expect(board.is_threadable).to be_true
      Settings.readonly = true
      expect(board.is_threadable).to be_false
    end

    it 'call #is_threadable?' do
      expect(board.is_threadable?).to be_true
      Settings.readonly = true
      expect(board.is_threadable?).to be_false
    end
  end

  it 'unpublish old treads' do
    board.treads << [FactoryGirl.create(:tread), FactoryGirl.create(:tread)]
    board.save
    expect(board.treads.published.count).to eq 2
    board.threads_number = 1
    board.save
    expect(board.treads.published.count).to eq 1
  end
end
