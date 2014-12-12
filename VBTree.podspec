#
# Be sure to run `pod lib lint VBTree.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VBTree"
  s.version          = "0.1.2"
  s.summary          = "A wrapper around CFTree"
  s.description      = <<-DESC
    You use VBTree to create tree structures that represent hierarchical organizations
    of information.

    In such structures, each tree node has exactly one parent tree
    (except for the root tree, which has no parent) and can have multiple children.
    Each VBTree object in the structure has a context associated with it; this context
    includes some program-defined data.
    DESC
  s.homepage         = "https://github.com/vbergae/VBTree"
  s.license          = 'MIT'
  s.author           = { "Victor Berga" => "vbergae@gmail.com" }
  s.source           = { :git => "https://github.com/vbergae/VBTree.git", :tag => s.version.to_s }

  s.ios.platform     = :ios, '7.0'
  s.osx.platform     = :osx, '10.9'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.public_header_files = 'Pod/Classes/**/*.h'
end
