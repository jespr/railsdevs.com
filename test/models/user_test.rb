require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "conversations where the user is the developer" do
    user = users(:with_developer_conversation)
    assert_equal user.conversations, [conversations(:one)]
  end

  test "conversations where the user is the business" do
    user = users(:with_business_conversation)
    assert_equal user.conversations, [conversations(:one)]
  end

  test "blocked conversations are ignored" do
    user = users(:with_business_conversation)
    assert user.conversations.include?(conversations(:one))
    refute user.conversations.include?(conversations(:blocked))
  end

  test "active business subscription" do
    user = users(:with_business)
    refute user.active_business_subscription?

    user.set_payment_processor(:fake_processor, allow_fake: true)
    user.payment_processor.subscribe(plan: "fake")
    assert user.reload.active_business_subscription?
  end
end
