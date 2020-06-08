require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:testuser)
  end

  test "validity" do
    assert @user.valid?
  end
end
