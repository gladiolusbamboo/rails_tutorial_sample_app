class Micropost < ApplicationRecord
  # MicropostモデルからUserモデルを参照できる
  belongs_to :user
  # デフォルトの並び順を指定できる
  default_scope -> { order(created_at: :desc) }
  # Micropostモデルに画像を追加する
  # 第一引数：モデルの属性名
  # 第二引数：アップローダーのクラス名
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # 独自のバリデーションを設定
  validate  :picture_size
  
  private

    # アップロードされた画像のサイズをバリデーションする
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
