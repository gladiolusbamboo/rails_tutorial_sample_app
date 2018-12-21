class Relationship < ApplicationRecord
  # フォロー関係、フォロワー関係のどちらにも属している
  # （中間モデルからどちらへも参照できる）
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
