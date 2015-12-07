Pod::Spec.new do |s|
s.name             = 'YMDropDownMenuNavBar'
s.version          = '0.1.2'
s.summary          = 'YMDropDownMenuNavBar is a blocks based nav bar menu, that enables assigning action balock for each menu item.'
s.description      = 'YMDropDownMenuNavBar is a blocks based nav bar menu, that enables assigning action balock for each menu item. The initialization is straight forward, just add pairs of menu item titles with their corresponding blocks.'
s.homepage         = 'https://github.com/pninael/YMDropDownMenuNavBar.git'
s.license          = 'MIT'
 s.author           = { "Pnina Eliyahu" => "pninae@microsoft.com" }
s.source           = { :git => "https://github.com/pninael/YMDropDownMenuNavBar.git", :tag => s.version.to_s }
s.platform         = :ios, '7.0'
s.requires_arc     = true
s.source_files = 'Pod/Classes/*'
s.resource_bundles = {
'YMDropDownMenuNavBar' => ['Pod/Assets/*']
}

end