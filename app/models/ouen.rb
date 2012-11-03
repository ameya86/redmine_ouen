class Ouen < ActiveRecord::Base
  has_many :ouen_users, :dependent => :destroy

  # "応援！"を＋１カウントする
  def self.plus_good(user, content_type, content_id)
    return self.plus_count(user, content_type, content_id, true)
  end

  # "頑張れ"を＋１カウントする
  def self.plus_more(user, content_type, content_id)
    return self.plus_count(user, content_type, content_id, false)
  end

  # カウントする
  def self.plus_count(user, content_type, content_id, mode)
    content_type = content_type.to_s.classify
    content_id = content_id.to_i

    content_class = nil
    begin
      content_class = content_type.constantize
    rescue NameError => ex
      # クラスの取得に失敗した場合はfalseを返して終わる
      return false
    end

    # 対象項目へのカウント情報を取得
    ouen = Ouen.find_by_content_type_and_content_id(content_type.to_s, content_id.to_i)

    if ouen
      ouen_user = OuenUser.find_by_ouen_id_and_user_id(ouen.id, user.id)

      if ouen_user
        if mode == ouen_user.good
          return false # カウント済みなら追加のカウントはしない
        end
        # "頑張れ"に投票していた場合は、"応援！"に切り替える
      else
        # 未投票
         ouen_user = OuenUser.new(:ouen_id => ouen.id, :user_id => user.id)
      end
      ouen_user.good = mode

      return ouen_user.save
    else
      # カウントがまだなかった場合は新規作成する
      ouen = Ouen.new(:content_type => content_type, :content_id => content_id)
      if ouen.save
        ouen_user =  OuenUser.new(:ouen_id => ouen.id, :user_id => user.id, :good => mode)
        return ouen_user.save
      end
    end

    return false
  end

  # カウント数の再計算
  def recount
    self.good_count = self.ouen_users.count(:conditions => ["good = ?", true])
    self.more_count = self.ouen_users.count(:conditions => ["good = ?", false])
  end

  # カウント数を再計算して保存
  def recount!
    self.recount
    self.save
  end

  # "応援！"をチケット一覧に表示させるためのクラス
  class Good
    attr_accessor :count
    attr_reader :ouen_id

    def initialize(ouen)
      @ouen_id = (ouen)? ouen.id : 0
      @count = (ouen)? ouen.good_count : 0
    end

    # カウント済みか？
    def user_posted?(user = User.current)
      return 0 != @ouen_id && OuenUser.exists?(['ouen_id = ? and user_id = ?', @ouen_id, user.id])
    end
  end

  # "頑張れ"をチケット一覧に表示させるためのクラス
  class More
    attr_reader :count
    attr_reader :ouen_id

    def initialize(ouen)
      @ouen_id = (ouen)? ouen.id : 0
      @count = (ouen)? ouen.more_count : 0
    end

    # カウント済みか？
    def user_posted?(user = User.current)
      return 0 != @ouen_id && OuenUser.exists?(['ouen_id = ? and user_id = ?', @ouen_id, user.id])
    end
  end
end
