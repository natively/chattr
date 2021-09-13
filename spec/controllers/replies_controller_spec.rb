require 'rails_helper'

require './spec/controllers/shared_examples'

describe RepliesController do
  let(:original_post) { FactoryBot.create(:post) }

  let(:commenter) { FactoryBot.create(:user) }

  let(:lurker) { FactoryBot.create(:user) }

  let(:reply) do
    FactoryBot.create(
      :reply,
      post: original_post,
      user: commenter,
      content: 'hello'
    )
  end

  describe 'POST create' do
    let(:params) do
      {
        reply: {
          content: 'here is a reply',
          post_id: original_post.id
        }
      }
    end

    subject(:make_request) { post :create, params: params }

    it_behaves_like('requires authentication')

    context 'signed in' do
      before { sign_in commenter }

      it 'creates a reply' do
        expect { make_request }.to(change { Reply.count }.by(1))
      end
    end
  end

  describe 'GET edit' do
    subject(:make_request) { get :edit, params: { id: reply.id } }

    it_behaves_like('requires authentication')

    context 'signed in' do
      context 'as the commenter' do
        before { sign_in commenter }

        it 'renders the edit page' do
          make_request

          expect(response).to(be_ok)
        end
      end

      context 'as a lurker' do
        before { sign_in lurker }

        it_behaves_like('requires authorization')
      end
    end
  end

  describe 'GET new' do
    subject(:make_request) { get :new }

    it_behaves_like('requires authentication')

    context 'signed in user' do
      before { sign_in commenter }

      it 'returns a page' do
        make_request

        expect(response).to(be_ok)
      end
    end
  end

  describe 'PUT update' do
    let(:params) do
      { id: reply.id, reply: { content: 'I never said that' } }
    end

    subject(:make_request) { put :update, params: params }

    context 'signed in' do
      context 'as the commenter' do
        before { sign_in commenter }

        it 'updates the content' do
          expect { make_request }
            .to(
              change { reply.reload.content }
                .from('hello')
                .to('I never said that')
            )
        end
      end

      context 'as a lurker' do
        before { sign_in lurker }

        it_behaves_like('requires authorization')
      end
    end
  end
end
