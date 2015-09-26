class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorite
  has_many :users ,through: :favotites
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end