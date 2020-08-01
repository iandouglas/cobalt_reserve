require 'rails_helper'

RSpec.describe Character, type: :model do
  describe 'relationships' do
    it { should belong_to :campaign }
    it { should belong_to :user }
    it { should have_many :game_session_characters }
    it { should have_many(:game_sessions).through(:game_session_characters) }
    it { should have_many :item_characters }
    it { should belong_to(:ancestryone) }
    it { should belong_to(:ancestrytwo).optional }
    it { should belong_to(:culture) }
    it { should have_many(:items).through(:item_characters) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:dndbeyond_url) }
    it { should validate_presence_of :klass }
    it { should validate_presence_of :level }
    it { should validate_numericality_of(:level).only_integer }

    describe 'doing things the hard way' do
      before :each do
        @user = create(:user)
        @campaign = create(:campaign)
        @c1 = create(
          :character,
          user: @user,
          campaign: @campaign,
          klass: 'Bard',
          name: 'Taylor Swift',
          dndbeyond_url: 'http://dndbeyond.com/1234'
        )
        @c2 = nil
      end

      it 'should validate uniqueness of name the hard way because shoulda_matchers is being a jerk' do
        begin
          @c2 = create(
            :character,
            user: @user,
            campaign: @campaign,
            klass: 'Bard',
            name: 'Taylor Swift',
            dndbeyond_url: 'http://dndbeyond.com/123456'
          )
        rescue ActiveRecord::RecordInvalid => e
          expect(e.message).to eq('Validation failed: Name has already been taken')
        end
        expect(@c2).to be_a(NilClass)
      end

      it 'should validate uniqueness of dndbeyond_url the hard way because shoulda_matchers is being a jerk' do
        begin
          @c3 = create(:character, user: @user, campaign: @campaign, dndbeyond_url: 'http://dndbeyond.com/1234')
        rescue ActiveRecord::RecordInvalid => e
          expect(e.message).to eq('Validation failed: Your DND Beyond Character Sheet has already been taken')
        end
        expect(@c3).to be_a(NilClass)
      end

      it 'validates that level is an integer between 1 and 20 because shoulda_matchers is being a jerk' do
        begin
          @c3 = create(:character, user: @user, campaign: @campaign, level: -1)
        rescue ActiveRecord::RecordInvalid => e
          expect(e.message).to eq('Validation failed: Your character level must be greater than 1')
        end
        expect(@c3).to be_a(NilClass)

        begin
          @c3 = create(:character, user: @user, campaign: @campaign, level: 21)
        rescue ActiveRecord::RecordInvalid => e
          expect(e.message).to eq('Validation failed: Your character level must be less than or equal to 20')
        end
        expect(@c3).to be_a(NilClass)
      end
    end
  end

  describe 'default properties' do
    it 'sets appropriate default values when creating a character' do
      user = create(:user)
      campaign = create(:campaign)
      char = create(:character, user: user, campaign: campaign)

      expect(char.active).to eq(true)
    end
  end

  describe 'scopes' do
    it '.active' do
      user = create(:user)
      campaign = create(:campaign)

      char1 = create(:character, user: user, campaign: campaign)
      char2 = create(:character, user: user, campaign: campaign)
      char3 = create(:inactive_character, user: user, campaign: campaign)
      expect(Character.active).to eq([char1, char2])
    end
  end

  describe 'instance methods' do
    it '.build_ancestry' do
      a1 = create(:ancestryone)
      a2 = create(:ancestrytwo)
      ch1 = create(:character, ancestryone: a1, ancestrytwo: nil)
      ch2 = create(:character, ancestryone: a1, ancestrytwo: a2)

      expect(ch1.build_ancestry). to eq(ch1.ancestryone.name)
      expect(ch2.build_ancestry). to eq("#{ch2.ancestryone.name} / #{ch2.ancestrytwo.name}")
    end
  end

  describe 'class methods' do
    it '.classes' do
      classes = Character.classes

      expect(classes).to be_a(Array)
      expect(classes).to_not include('')
      expect(classes).to include('Artificer')
      expect(classes).to include('Barbarian')
      expect(classes).to include('Bard')
      expect(classes).to include('Blood Hunter')
      expect(classes).to include('Cleric')
      expect(classes).to include('Druid')
      expect(classes).to include('Fighter')
      expect(classes).to include('Monk')
      expect(classes).to include('Paladin')
      expect(classes).to include('Ranger')
      expect(classes).to include('Rogue')
      expect(classes).to include('Sorcerer')
      expect(classes).to include('Warlock')
      expect(classes).to include('Wizard')
    end
  end
end
