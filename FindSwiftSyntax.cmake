include(./FetchHyloDependency)

# swift-syntax places its modules in the `<name>.swiftmodule/<triple>.swiftmodule` layout by passing
# `-emit-module-path`. Since CMake 4.4.3, CMake no longer notices that flag and emits a
# `<name>.swiftmodule` file that shadows the directory, unless CMP0195 makes CMake use the same
# layout. Newer swift-syntax versions do this themselves (apple/swift-syntax@a71ab65), so we can 
# remove this once they are released and our Swift compiler version is bumped.
set(CMAKE_POLICY_DEFAULT_CMP0195 NEW)
fetch_hylo_dependency(SwiftSyntax
  GIT_REPOSITORY https://github.com/apple/swift-syntax.git
  GIT_TAG        603.0.2
)
unset(CMAKE_POLICY_DEFAULT_CMP0195)

# Suppress noisy warnings
target_compile_options(SwiftCompilerPluginMessageHandling PRIVATE -suppress-warnings)
target_compile_options(SwiftParser PRIVATE -suppress-warnings)
target_compile_options(SwiftParserDiagnostics PRIVATE -suppress-warnings)
target_compile_options(SwiftSyntaxMacroExpansion PRIVATE -suppress-warnings)
target_compile_options(SwiftOperators PRIVATE -suppress-warnings)
