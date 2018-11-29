class User < ApplicationRecord
  # email保存前に小文字にする
  before_save { email.downcase! }

  validates :name, 
    # nameは存在しなければならない
    presence: true, 
    # nameは50文字以内でなければならない
    length: { maximum: 50 }

  # emailの形式を確認する正規表現
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, 
    # emailは存在しなければならない
    presence: true, 
    # emailは255文字以内でなければならない
    length: { maximum: 255 },
    # emailは正規表現に合致するか
    format: { with: VALID_EMAIL_REGEX },
    # emailは重複していないか
    # 大文字小文字の違いは別のemailとはみなさない
    uniqueness: { case_sensitive: false }
end
