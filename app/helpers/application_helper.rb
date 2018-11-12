# ここに汎用的なヘルパーメソッドを書いていく
module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  # デフォルト引数を使用する
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
