class Micropost < ApplicationRecord
  # MicropostモデルからUserモデルを参照できる
  belongs_to :user
  # デフォルトの並び順を指定できる
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end
