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

list(PREPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)

if (PROJECT_IS_TOP_LEVEL)
  include(${PROJECT_SOURCE_DIR}/cmake/TopLevelDefaults.cmake)
endif()



#
# Local targets
#

add_executable(generate-xctest-main Sources/GenerateXCTestMain.swift)
target_link_libraries(generate-xctest-main
  ArgumentParser
  SwiftSyntax
  SwiftSyntaxBuilder
  SwiftOperators
  SwiftParser
  SwiftParserDiagnostics
)
# Needed where @main is used.
target_compile_options(generate-xctest-main PRIVATE -parse-as-library)

if(ENABLE_TESTING)
  include(${PROJECT_SOURCE_DIR}/cmake/modules/SwiftCMakeXCTesting.cmake)
  add_library(DummyTestee STATIC ${PROJECT_SOURCE_DIR}/Tests/Dummy.swift)
  target_compile_options(DummyTestee PRIVATE -enable-testing)

  add_swift_xctest(XCTestBridgeTests DummyTestee ${PROJECT_SOURCE_DIR}/Tests/Tests.swift)
endif()
