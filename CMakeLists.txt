cmake_minimum_required(VERSION 3.26)

project(SwiftCMakeXCTesting LANGUAGES Swift)
enable_testing()

if (PROJECT_IS_TOP_LEVEL)
  include(${PROJECT_SOURCE_DIR}/cmake/TopLevelDefaults.cmake)
endif()

#
# Dependencies
#

include(FetchContent)

set(_XCTESTDISCOVERY_SAVED_BUILD_TESTING ${BUILD_TESTING})
set(_XCTESTDISCOVERY_SAVED_BUILD_EXAMPLES ${BUILD_EXAMPLES})
set(_XCTESTDISCOVERY_VENDOR_DEPENDENCIES)

set(BUILD_EXAMPLES NO)
set(BUILD_TESTING NO)

if("${SWIFT_HOST_MODULE_TRIPLE}" STREQUAL "")
  execute_process(COMMAND ${CMAKE_Swift_COMPILER} -print-target-info OUTPUT_VARIABLE target-info)
  string(JSON SWIFT_HOST_MODULE_TRIPLE GET ${target-info} target moduleTriple)
endif()

FetchContent_Declare(SwiftSyntax
  GIT_REPOSITORY https://github.com/apple/swift-syntax.git
  GIT_TAG        main
  FIND_PACKAGE_ARGS CONFIG
)

FetchContent_Declare(ArgumentParser
  GIT_REPOSITORY https://github.com/apple/swift-argument-parser.git
  GIT_TAG        1.3.0
  FIND_PACKAGE_ARGS CONFIG
)

FetchContent_MakeAvailable(ArgumentParser SwiftSyntax)
target_compile_options(SwiftCompilerPluginMessageHandling PRIVATE -suppress-warnings)
target_compile_options(SwiftParser PRIVATE -suppress-warnings)
target_compile_options(SwiftParserDiagnostics PRIVATE -suppress-warnings)
target_compile_options(SwiftSyntaxMacroExpansion PRIVATE -suppress-warnings)
target_compile_options(SwiftOperators PRIVATE -suppress-warnings)

set(BUILD_TESTING ${_XCTESTDISCOVERY_SAVED_BUILD_TESTING})
set(BUILD_EXAMPLES ${_XCTESTDISCOVERY_SAVED_BUILD_EXAMPLES})

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
