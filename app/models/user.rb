class User < ApplicationRecord
  validates :name, 
    # nameは存在しなければならない
    presence: true, 
    # nameは50文字以内でなければならない
    length: { maximum: 50 }

  validates :email, 
    # emailは存在しなければならない
    presence: true, 
    # emailは255文字以内でなければならない
    length: { maximum: 255 }
end
