require_dependency 'principal'
require_dependency 'user'

# ユーザの削除時にカウントも消す

class User < Principal
  has_many :ouen_users

  before_destroy :ouen_update

  # カウントを再計算する
  def ouen_update
    ouen_ids = ouen_users.collect(&:ouen_id)
    # 自身に紐付いているカウントを全て削除する
    OuenUser.destroy_all(:user_id => self.id)

    ouens = Ouen.find(:all, :conditions => ['id in (?)', ouen_ids])
    ouens.each{|o| o.recount!}
  end
end
