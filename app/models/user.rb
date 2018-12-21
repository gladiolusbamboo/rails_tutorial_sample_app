class User < ApplicationRecord
  # Userは多数のMicropostsを持っている
  # Userが削除されたら紐付いているMicropostsも削除する
  has_many :microposts, dependent: :destroy
  # Userは多数の"フォロー関係"を持っている
  # フォロー関係モデルはRelationshipクラスであらわされる
  # フォロー相手は外部キーfollower_idで参照される
  # ユーザーモデルが削除されると"フォロー関係"も破棄される
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
                                  
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
    length: { minimum: 6 },
    # validatesでは空のパスワードを許容するが
    # has_secure_passwordでは許容されないので問題ない
    allow_nil: true
  
  # 渡された文字列のハッシュ値を返す
  # クラスメソッドとして定義する
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  # ユーザーが投稿したすべてのMicropostを返す
  def feed
    Micropost.where("user_id = ?", id)
  end
end
