require 'rails_helper'

RSpec.describe Screenshot, type: :model do
  it {should belong_to(:vn)}
end
