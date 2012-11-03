require 'ouen_patch'

Redmine::Plugin.register :redmine_ouen do
  name 'Redmine Ouen plugin'
  author 'OZAWA Yasuhiro'
  description 'Good and More'
  version '0.0.1'
  url 'https://github.com/ameya86/redmine_ouen'
  author_url 'https://github.com/ameya86'

  settings :default => {
      'good_enabled' => '1',
      'more_enabled' => '1',
    }, :partial => 'ouens/settings'
end
