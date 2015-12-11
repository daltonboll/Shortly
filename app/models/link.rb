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
#  user_id     :integer
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

  # Returns the title of this link
  def get_title
    title = self.title

    if title.nil?
      return ""
    else
      return title
    end
  end

  # Returns the description of this link
  def get_description
    description = self.description

    if description.nil?
      return ""
    else
      return description
    end
  end

  # Returns the short url of this link
  def get_shorturl(root_path)
    path = self.shortened
    base = root_path
    shorturl = base + path
    return shorturl
  end

  # Returns the full url of this link
  def get_url
    url = self.destination
    return url
  end

  # Returns the number of times this url has been favorited
  def get_favorite_count
    favorites = self.favorited
    favorite_count = favorites.size
    return favorite_count
  end

  # Returns the list of users who have favorited this link
  def get_favorited_users
    user_ids = self.favorited
    if user_ids.empty?
      return "None"
    else
      users = ""

      user_ids.each do |user_id|
        user = User.find_by(id: user_id)

        if not user.nil?
          users += user.id + ", "
        end
      end

      if users.size > 0
        users = users[0, users.size - 2]
      end

      return users
    end
  end

  # Returns the user who owns this link
  def get_user
    return self.user.id
  end

  # Returns true if this link belongs to the specified user
  def belongs_to_user(user_id)
    return self.user.id == user_id
  end

  # Add this link to the specified user's favorites
  def favorite(user_id)
    user = User.find_by(id: user_id)

    if not user.nil? and not user.favorites.include? self.id
      user.favorites << self.id
      user.save
      puts "Added link# #{self.id} to user# #{user_id}'s favorites"
    end
  end

  # Remove this link from the specified user's favorites
  def unfavorite(user_id)
    user = User.find_by(id: user_id)

    if not user.nil? and user.favorites.include? self.id
      user.favorites.delete(self.id)
      user.save
      puts "Removed link# #{self.id} from user# #{user_id}'s favorites"
    else
      puts "Couldn't remove link# #{self.id} to user# #{user_id}'s favorites"
    end
  end

end
