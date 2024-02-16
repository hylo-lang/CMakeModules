# Fetches dependencies for SwiftCMakeXCTesting.
include(FetchContent)

# See https://github.com/apple/swift-syntax/pull/2454, which will hopefully make this clause
# unnecessary.  Without it CMake will fatal error when loading SwiftSyntax on some platforms.
if("${SWIFT_HOST_MODULE_TRIPLE}" STREQUAL "")
  execute_process(COMMAND ${CMAKE_Swift_COMPILER}
    -print-target-info OUTPUT_VARIABLE target-info)
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

set(_XCTESTDISCOVERY_SAVED_BUILD_TESTING ${BUILD_TESTING})
set(_XCTESTDISCOVERY_SAVED_BUILD_EXAMPLES ${BUILD_EXAMPLES})

set(BUILD_EXAMPLES NO)
set(BUILD_TESTING NO)

FetchContent_MakeAvailable(ArgumentParser SwiftSyntax)

target_compile_options(SwiftCompilerPluginMessageHandling PRIVATE -suppress-warnings)
target_compile_options(SwiftParser PRIVATE -suppress-warnings)
target_compile_options(SwiftParserDiagnostics PRIVATE -suppress-warnings)
target_compile_options(SwiftSyntaxMacroExpansion PRIVATE -suppress-warnings)
target_compile_options(SwiftOperators PRIVATE -suppress-warnings)


set(BUILD_TESTING ${_XCTESTDISCOVERY_SAVED_BUILD_TESTING})
set(BUILD_EXAMPLES ${_XCTESTDISCOVERY_SAVED_BUILD_EXAMPLES})
