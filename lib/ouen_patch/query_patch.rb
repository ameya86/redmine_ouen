require_dependency 'query'

# チケットの列を追加する

module OuenPatch
  module QueryPatch
    def self.included(base) # :nodoc:
      base.send(:include, InstanceMethods) # obj.method

      base.class_eval do
        alias_method_chain :available_columns, :ouen
      end
    end

    module InstanceMethods # obj.method
      # チケット列に"応援！"と"頑張れ"を追加
      def available_columns_with_ouen
        unless @available_columns_with_ouen
          # 1回だけ実行する
          columns = available_columns_without_ouen

          if  '1' == Setting.plugin_redmine_ouen['good_enabled'].to_s
            columns << QueryColumn.new(:ouen_good, :sortable => "ouens.good", :default_order => 'desc')
          end

          if  '1' == Setting.plugin_redmine_ouen['more_enabled'].to_s
            columns << QueryColumn.new(:ouen_more, :sortable => "ouens.more", :default_order => 'desc')
          end          

          @available_columns_with_ouen = columns
        end

        return @available_columns_with_ouen
      end
    end
  end
end

Query.send(:include, OuenPatch::QueryPatch)
