# frozen_string_literal: true

require 'rails_helper'

require './spec/controllers/shared_examples'

describe PostsController do
  let(:original_poster) { FactoryBot.create(:user) }

  let!(:original_post) do
    FactoryBot.create(:post, user: original_poster, content: 'some words')
  end

  let(:lurker) { FactoryBot.create(:user) }

  describe 'GET show' do
    let!(:reply_1) { FactoryBot.create(:reply, post: original_post) }

    let!(:reply_2) { FactoryBot.create(:reply, post: original_post) }

    subject(:make_request) { get :show, params: { id: original_post.id } }

    before { sign_in lurker }

    it 'shows the replies' do
      make_request

      expect(assigns(:replies)).to(eq([reply_1, reply_2]))
    end
  end

  describe 'POST create' do
    let(:params) do
      { post: {  title: 'title goes here', content: 'body here' } }
    end

    subject(:make_request) { post :create, params: params }

    it_behaves_like('requires authentication')

    context 'signed in' do
      before do
        sign_in original_poster
      end

      it 'creates a post' do
        expect { make_request }.to(change { Post.count }.by(1))
      end
    end
  end

  describe 'GET index' do
    subject(:make_request) { get :index }

    it_behaves_like('requires authentication')

    context 'signed in' do
      before { sign_in lurker }

      it 'shows the posts' do
        make_request

        expect(assigns(:posts)).to(eq([original_post]))
      end
    end
  end

  describe 'GET edit' do
    subject(:make_request) { get :edit, params: { id: original_post.id } }

    it_behaves_like('requires authorization')
  end

  describe 'PUT update' do
    let(:params) do
      {
        id: original_post.id,
        post: { content: 'something else for the body' }
      }
    end

    subject(:make_request) { put :update, params: params }

    it_behaves_like('requires authorization')

    context 'signed in' do
      context 'as the OP' do
        before { sign_in original_poster }

        it 'updates the content' do
          expect { make_request }
            .to(
              change { original_post.reload.content }
                .from('some words')
                .to('something else for the body')
            )
        end
      end

      context 'as not the OP' do
        before { sign_in lurker }

        it_behaves_like('requires authorization')
      end
    end
  end
end
