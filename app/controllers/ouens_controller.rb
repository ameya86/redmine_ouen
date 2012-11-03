class OuensController < ApplicationController
  before_filter :require_login

  # "応援！"
  def good
    if request.post? && params[:content_type] && params[:content_id]
      if Ouen.plus_good(User.current, params[:content_type], params[:content_id])
        flash[:notice] = 'ok'
      else
        flash[:warning] = 'duplicated.'
      end
    end

    # 前のページに戻る
    redirect_to back_url
  end

  # "頑張れ"
  def more
    if request.post? && params[:content_type] && params[:content_id]
      if Ouen.plus_more(User.current, params[:content_type], params[:content_id])
        flash[:notice] = 'ok'
      else
        flash[:warning] = 'duplicated.'
      end
    end

    # 前のページに戻る
    redirect_to back_url
  end
end
