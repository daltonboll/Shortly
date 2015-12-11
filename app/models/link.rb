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
  validates :shortened, uniqueness: true, allow_nil: true
  validates :shortened, length: { minimum: 4, maximum: 12 }, allow_blank: true
  belongs_to :user

  # Returns true if the provided url is valid
  def self.is_valid_url(url)
    uri = URI.parse(url)
    uri.kind_of?(URI::HTTP)
    rescue URI::InvalidURIError
      false
  end

  # Generates a random string for a short url
  def self.generate_string
    min_length = 4
    max_length = 12
    generated_string = ""

    characters = ("A".."Z").to_a + ("a".."z").to_a + (0..9).to_a
    num_characters = characters.size - 1
    length = Random.rand(min_length..max_length)

    length.times do |i|
      character = characters[Random.rand(0..num_characters)].to_s
      generated_string += character
    end

    return generated_string
  end

  # Sets self.shortened to a unique string
  def assign_unique_shortened_string
    shortened = Link.generate_string
    self.shortened = shortened

    while not self.save
      shortened = Link.generate_string
      self.shortened = shortened
    end
  end

end
