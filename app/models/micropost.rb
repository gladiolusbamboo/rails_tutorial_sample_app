class Micropost < ApplicationRecord
  # MicropostモデルからUserモデルを参照できる
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
