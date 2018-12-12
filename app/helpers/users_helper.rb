module UsersHelper
  # 引数で与えられたユーザーのGravatar画像を返す
  # サイズを指定できる
  def gravatar_for(user, options = { size: 80 })
    # GravatarのURLはユーザーのメールアドレスをMD5という仕組みでハッシュ化している
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # こんな感じのHTMLが生成される
    # <img alt="Example User" class="gravatar" src="https://secure.gravatar.com/avatar/bebfcf57d6d8277d806a9ef3385c078d">
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
