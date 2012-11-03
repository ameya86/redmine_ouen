require_dependency 'queries_helper'

module OuenPatch
  module QueriesHelperPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods) # obj.method

      base.class_eval do
        alias_method_chain :column_value, :ouen
      end
    end

    module InstanceMethods # obj.method
      # 追加した列の表示パターンを追加
      def column_value_with_ouen(column, issue, value)
        case value.class.name
        when 'Ouen::Good'
          # "応援！"
          if User.current.logged?
            return link_to(issue.ouen_good.count,
                           {:controller => 'ouens', :action => 'good', :content_type => 'issue', :content_id => issue.id},
                           :method => :post, :confirm => l(:text_ouen_good_post))
          else
            return issue.ouen_good.count
          end
        when 'Ouen::More'
          # "頑張れ"
          if User.current.logged?
            return link_to(issue.ouen_more.count,
                           {:controller => 'ouens', :action => 'more', :content_type => 'issue', :content_id => issue.id},
                            :method => :post, :confirm => l(:text_ouen_more_post))
          else
            return issue.ouen_more.count
          end
        else
          # その他
          return column_value_without_ouen(column, issue, value)
        end
      end
    end
  end
end

QueriesHelper.send(:include, OuenPatch::QueriesHelperPatch)
