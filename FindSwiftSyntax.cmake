include(./FetchHyloDependency)

fetch_hylo_dependency(SwiftSyntax
  GIT_REPOSITORY https://github.com/apple/swift-syntax.git
  GIT_TAG        b32df0ee1af3989b466286f59fce285f8ec57d6f
)

# Suppress noisy warnings
target_compile_options(SwiftCompilerPluginMessageHandling PRIVATE -suppress-warnings)
target_compile_options(SwiftParser PRIVATE -suppress-warnings)
target_compile_options(SwiftParserDiagnostics PRIVATE -suppress-warnings)
target_compile_options(SwiftSyntaxMacroExpansion PRIVATE -suppress-warnings)
target_compile_options(SwiftOperators PRIVATE -suppress-warnings)
