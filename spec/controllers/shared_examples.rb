RSpec.shared_examples 'requires authentication' do
  it 'raises for unauthenticated users' do
    make_request

    expect(make_request).to(redirect_to('/users/sign_in'))
  end
end

RSpec.shared_examples 'requires authorization' do
  before { sign_in(lurker) }

  it 'returns a 401' do
    make_request

    expect(response.status).to(eq(401))
  end
end
