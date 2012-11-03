class OuenUser < ActiveRecord::Base
  belongs_to :ouen
  belongs_to :user

  after_save :ouen_update

  # カウントが変化したらカウント数を再計算する
  def ouen_update
    ouen.recount!
  end
end
