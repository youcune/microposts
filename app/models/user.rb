class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :description ,presence: true
  validates :location ,presence: true
  has_secure_password
  has_many :microposts ,through: :favorites
  belongs_to :favorite
  
  def feed_items
    Micropost.where(user_id: following_user_ids + [self.id])
  end

  has_many :following_relationships, class_name:  "Relationship",
                                     foreign_key: "follower_id",
                                     dependent:   :destroy
  has_many :following_users, through: :following_relationships, source: :followed
  has_many :follower_relationships, class_name:  "Relationship",
                                    foreign_key: "followed_id",
                                    dependent:   :destroy
  has_many :follower_users, through: :follower_relationships, source: :follower
 
 
  # お気に入り関係
  def favorite_items
    Micropost.where(micropost_id: favorite_microposts)
  end  
  
  has_many :favorites, dependent: :destroy
  has_many :favorite_microposts, class_name: "Micropost",
                                 through: :favorites,
                                 foreign_key: "micropost_id",
                                 dependent: :destroy
                              
  # ツイートをお気に入り追加
  def favorite(other_micropost)
    favorite_microposts.create(micropost_id: other_micropost.id)
  end  
  
  # ツイートをお気に入り解除
  def unfavorite(other_micropost)
    favorite_microposts.find_by(micropost_id: other_micropost.id).destroy
  end
  
   # お気に入りしているかの判定
  def favorite?(other_micropost)
    favorite_users.include?(other_micropost)
  end  
  
  # 他のユーザーをフォローする
  def follow(other_user)
    following_relationships.create(followed_id: other_user.id)
  end

  # フォローしているユーザーをアンフォローする
  def unfollow(other_user)
    following_relationships.find_by(followed_id: other_user.id).destroy
  end

  # あるユーザーをフォローしているかどうか？
  def following?(other_user)
    following_users.include?(other_user)
  end
end
