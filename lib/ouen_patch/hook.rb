module OuenPatch
  class Hook < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, :partial => 'ouens/issues_show_details_bottom'
  end
end
