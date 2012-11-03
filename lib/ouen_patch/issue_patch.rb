require_dependency 'issue'

class Issue < ActiveRecord::Base
  has_one :ouen, :foreign_key => 'content_id', :conditions => ["content_type = ?", 'Issue'], :dependent => :destroy

  # "応援！"
  def ouen_good
    return Ouen::Good.new(self.ouen)
  end

  # "頑張れ"
  def ouen_more
    return Ouen::More.new(self.ouen)
  end
end
