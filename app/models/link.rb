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

class Link < ActiveRecord::Base
  require 'uri' # For checking if a URL is valid
  validates :destination, url: true

  # Returns true if the provided url is valid
  def self.is_valid_url(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
  end

end
