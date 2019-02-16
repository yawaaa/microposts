class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sencitive: false}
  has_secure_password
  
  has_many :microposts
  # これを書かないとどうなる？ → user.micropostとかが出来なくなる
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  
  has_many :reverses_of_relationship, class_name: "Relationship", foreign_key: "follow_id"
  has_many :followers, through: :reverses_of_relationship, source: :user

  # follow => favpost, following => favoring
  # user_id -> user_id.favorites -> user_id.favorings(favpost)
  # favpost_id.favored(user) <- favpost_id.reverses... <- favpost_id
  has_many :favorites
  has_many :favorings, through: :favorites, source: :favpost
  has_many :reverses_of_favorate, class_name: "Favorite", foreign_key: "favpost_id"
  has_many :favored, through: :reverses_of_favorate, source: :user
  

  def follow(other_user)
    # 実行したUserのインスタンスがself
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end
  
  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end
    
  def following?(other_user)
    self.followings.include?(other_user)
  end

  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
    #自分のフォロワーのid達(配列)と、自分のidを配列に格納したもの、、、、を探して全postを取得
  end
  
  def favpost(target_micropost)
    # 自分のポストをファボしてもいい
    self.favorites.find_or_create_by(favpost_id: target_micropost.id)
  end

  def unfavpost(target_micropost)
    unfav_target = self.favorites.find_by(favpost_id: target_micropost.id)
    unfav_target.destroy if unfav_target
  end
  
   def fav?(target_micropost)
    self.favorings.include?(target_micropost)
   end
  
end