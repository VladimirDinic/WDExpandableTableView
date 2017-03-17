Pod::Spec.new do |s|

s.platform = :ios
s.name             = "WDExpandableTableView"
s.version          = "0.0.3"
s.summary          = "WDExpandableTableView is a keyboard manager for iOS apps."

s.description      = <<-DESC
This library enables you to setup expandable table view in several simple steps.
DESC

s.homepage         = "https://github.com/VladimirDinic/WDExpandableTableView"
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author           = { "Vladimir Dinic" => "vladimir88dev@gmail.com" }
s.source           = { :git => "https://github.com/VladimirDinic/WDExpandableTableView.git", :tag => "#{s.version}"}

s.ios.deployment_target = "10.0"
s.source_files = "WDExpandableTableView/WDExpandableTableView/WDExpandableTableView/*"

end
