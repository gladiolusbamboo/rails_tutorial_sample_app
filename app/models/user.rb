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
    
  # Railsメソッド。セキュアなパスワードを実装する
  # passwordおよびpassword_confirmation属性が必要
  has_secure_password
  
  validates :password, 
    # password属性は存在していなければならない
    presence: true, 
    # password属性は６文字以上でなければならない
    length: { minimum: 5 }
end
