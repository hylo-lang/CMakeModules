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
enable_testing()

set(CMAKE_XCODE_GENERATE_SCHEME YES)

list(PREPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

option(SwiftCMakeXCTesting_FORCE_BUILD_GenerateXCTestMain
  "Force-build GenerateXCTestMain on platforms where it's not needed." OFF)
mark_as_advanced(SwiftCMakeXCTesting_FORCE_BUILD_GenerateXCTestMain)

if (PROJECT_IS_TOP_LEVEL)
  include(cmake/TopLevelDefaults.cmake)
endif()

if(NOT APPLE OR SwiftCMakeXCTesting_FORCE_BUILD_GenerateXCTestMain)
  add_subdirectory(Sources)
endif()

if(ENABLE_TESTING)
  add_subdirectory(Tests)
endif()
