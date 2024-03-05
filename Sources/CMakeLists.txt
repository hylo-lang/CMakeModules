find_package(ArgumentParser REQUIRED)
find_package(SwiftSyntax REQUIRED)

add_executable(GenerateXCTestMain GenerateXCTestMain.swift)
target_link_libraries(GenerateXCTestMain
  ArgumentParser
  SwiftSyntax
  SwiftSyntaxBuilder
  SwiftOperators
  SwiftParser
  SwiftParserDiagnostics
)

# Needed where @main is used.
target_compile_options(GenerateXCTestMain PRIVATE -parse-as-library)
