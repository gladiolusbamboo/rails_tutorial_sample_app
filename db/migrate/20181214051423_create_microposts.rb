class CreateMicroposts < ActiveRecord::Migration[5.1]
  def change
    create_table :microposts do |t|
      t.text :content
      # Userテーブルを参照する外部キーを持つ
      t.references :user, foreign_key: true

      t.timestamps
    end
    # ユーザーIDとポスト作成時間を
    # インデックスに設定する
    add_index :microposts, [:user_id, :created_at]
  end
end
