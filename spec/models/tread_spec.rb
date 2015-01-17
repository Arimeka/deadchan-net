require 'spec_helper'

describe Tread do
  let(:tread) { FactoryGirl.create(:tread) }
  let(:board) { FactoryGirl.create(:board, is_threadable: false) }
  let(:post)  { FactoryGirl.create(:post) }

  subject { tread }

  context 'respond and valid' do
    it { should respond_to(:board_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:title) }
    it { should respond_to(:content) }
    it { should respond_to(:published_at) }
    it { should respond_to(:updated_at) }
    it { should respond_to(:replies) }
    it { should respond_to(:is_commentable) }
    it { should respond_to(:is_published) }
    it { should respond_to(:is_pinned) }
    it { should respond_to(:is_full) }
    it { should respond_to(:is_admin) }
    it { should respond_to(:posts_number) }
    it { should respond_to(:request_ip) }

    it { should respond_to(:board) }
    it { should respond_to(:user) }
    it { should respond_to(:posts) }
    it { should respond_to(:image) }

    it { should be_valid }
  end

  context 'not valid' do
    context 'without' do
      it 'title' do
        tread.title = nil
        expect(tread).to be_invalid
      end

      it 'content if has no image' do
        tread.content = nil
        expect(tread).to be_invalid
      end

      it 'posts_number' do
        tread.posts_number = nil
        expect(tread).to be_invalid
      end

      it 'board_id' do
        tread.board_id = nil
        expect(tread).to be_invalid
      end

      it 'is_pinned' do
        tread.is_pinned = nil
        expect(tread).to be_invalid
      end

      it 'is_published' do
        tread.is_published = nil
        expect(tread).to be_invalid
      end

      it 'is_commentable' do
        tread.is_commentable = nil
        expect(tread).to be_invalid
      end

      it 'is_full' do
        tread.is_full = nil
        expect(tread).to be_invalid
      end
    end

    context 'with too short' do
      it 'title' do
        tread.title = Faker::Lorem.characters(1)
        expect(tread).to be_invalid
      end

      it 'title' do
        tread.content = ''
        expect(tread).to be_invalid
      end
    end

    context 'with too long' do
      it 'title' do
        tread.title = Faker::Lorem.characters(40)
        expect(tread).to be_invalid
      end

      it 'content' do
        tread.content = Faker::Lorem.characters(2700)
        expect(tread).to be_invalid
      end
    end

    context 'with not integer' do
      it 'posts_number' do
        tread.posts_number = 1.1
        expect(tread).to be_invalid

        tread.posts_number = 'foobar'
        expect(tread).to be_invalid
      end
    end

    it 'on create if board not threadable' do
      tread = FactoryGirl.build(:tread, board: board)
      expect(tread).to be_invalid
    end
  end

  context 'scope :published return' do
    before :each do
      tread
    end

    it 'only published treads' do
      new_tread = FactoryGirl.create(:tread, is_published: false)
      expect(Tread.published.to_a).to eq [tread]
    end

    it 'only presented treads' do
      new_tread = FactoryGirl.create(:tread, published_at: Time.now + 1.day)
      expect(Tread.published.to_a).to eq [tread]
    end

    it 'treads sorted by is_pinned and updated_at' do
      first = FactoryGirl.create(:tread, is_pinned: true)
      second = FactoryGirl.create(:tread, is_pinned: true)
      third = FactoryGirl.create(:tread)

      first.touch
      tread.touch

      expect(Tread.published.to_a).to eq [first,second,tread,third]
    end
  end

  context 'check Settings.readonly before' do
    before(:each) do
      Settings.readonly = nil
    end
    after(:each) do
      Settings.readonly = nil
    end

    it 'call #is_commentable' do
      expect(tread.is_commentable).to be_true
      Settings.readonly = true
      expect(tread.is_commentable).to be_false
    end

    it 'call #is_commentable?' do
      expect(tread.is_commentable?).to be_true
      Settings.readonly = true
      expect(tread.is_commentable?).to be_false
    end
  end

  context 'before save' do
    it 'set published_at if tread just published and published_at not seted' do
      tread = FactoryGirl.create(:tread, is_published: false)
      tread.update(published_at:  nil)
      expect(tread.published_at).to be_nil
      tread.update(is_published:  true)
      expect(tread.published_at).to_not be_nil
    end

    it 'bump updated_at if tread not full' do
      updated_at_before = tread.updated_at
      sleep(1)
      tread.touch
      expect(tread.updated_at.to_i).to_not eq updated_at_before.to_i
    end

    it 'not bump updated_at if tread is full' do
      tread = post.tread
      tread.update(posts_number: 0)
      updated_at_before = tread.updated_at
      tread.touch
      expect(tread.updated_at.to_i).to eq updated_at_before.to_i
    end
  end

  context 'before create' do
    it 'set published_at if tread is published' do
      expect(tread.published_at).to_not be_nil
    end

    it 'not set published_at if tread is not published' do
      tread = FactoryGirl.create(:tread, is_published: false)
      expect(tread.published_at).to be_nil
    end
  end

  it 'after create unpublish old treads' do
    board = tread.board
    board.treads << [FactoryGirl.create(:tread), FactoryGirl.create(:tread)]
    board.save
    expect(board.treads.published.count).to eq 3
    board.threads_number = 1
    board.save
    expect(board.treads.published.count).to eq 1
  end
end
