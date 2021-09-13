# frozen_string_literal: true

require 'rails_helper'

describe Reply do
  context 'associations' do
    it { is_expected.to(belong_to(:post)) }

    it { is_expected.to(belong_to(:user)) }
  end

  context 'validations' do
    it { is_expected.to(validate_presence_of(:content)) }

    it { is_expected.to(validate_presence_of(:post)) }

    it { is_expected.to(validate_presence_of(:user)) }

    it { is_expected.to(validate_length_of(:content).is_at_least(1)) }
  end

  context 'callbacks' do
    context 'after_create' do
      let(:post) { FactoryBot.create(:post) }

      it 'updates the posts created_at' do
        expect { FactoryBot.create(:reply, post: post) }
          .to(change { post.reload.updated_at })
      end
    end
  end
end
