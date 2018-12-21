class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    # ユーザーの関係を表す中間テーブル
    # フォローしている関係を表すactive_relationshipと
    # フォローされている関係を表すpassive_relationshipがある
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # Relationshipの重複を防ぐ
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
