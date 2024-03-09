cmake_minimum_required(VERSION 3.26)

#
# Standard project boilerplate
#
project(SwiftCMakeXCTesting
  VERSION 0.1.0
  DESCRIPTION "Cross-platform support for using XCTest in Swift projects"
  HOMEPAGE_URL "https://github.com/hylo-lang/SwiftCMakeXCTesting"
  LANGUAGES Swift
)

list(PREPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)
