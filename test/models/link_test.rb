# == Schema Information
#
# Table name: links
#
#  id          :integer          not null, primary key
#  destination :string
#  shortened   :string
#  favorited   :integer          default([]), is an Array
#  description :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
