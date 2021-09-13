# frozen_string_literal: true

describe User do
  it { is_expected.to(validate_presence_of(:name)) }
end
