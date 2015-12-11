# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  favorites              :integer          default([]), is an Array
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :links
  
  # Get this user's favorite links
  def favorite_links
    favorite_ids = self.favorites
    original_length = favorite_ids.size
    favorite_links = []

    favorite_ids.each do |id|
      link = Link.find_by(id: id)

      if link.nil?
        favorite_ids.delete(id)
      else
        favorite_links << link
      end
    end

    if favorite_ids.size != original_length
      self.save
    end

    return favorite_links
  end

  # Returns true if this user has favorited the specified link
  def has_favorited(link_id)
    return self.favorites.include? link_id
  end

end
