# frozen_string_literal: true

require 'rails_helper'

describe Post do
  context 'associations' do
    it { is_expected.to(belong_to(:user)) }
  end

  context 'validations' do
    it { is_expected.to(validate_presence_of(:content)) }

    it { is_expected.to(validate_presence_of(:title)) }

    it { is_expected.to(validate_presence_of(:user)) }

    it { is_expected.to(validate_length_of(:content).is_at_least(5)) }

    it { is_expected.to(validate_length_of(:title).is_at_least(5)) }

    it { is_expected.to(validate_length_of(:title).is_at_most(120)) }
  end

  context 'scopes' do
    let!(:post) { FactoryBot.create(:post) }

    describe 'default_scope' do
      subject { described_class.all }

      context 'post is not deleted' do
        it { is_expected.to(include(post)) }
      end

      context 'post is deleted' do
        before do
          post.update(deleted: true)
        end

        it { is_expected.to_not(include(post)) }
      end
    end

    describe '.homepage' do
      it 'includes the post' do
        expect(Post.homepage(1)).to(include(post))
      end
    end
  end
end
