include(./FetchHyloDependency)

# ArgumentParser relies on XCTest even in its non-test code and it
# seems not to have the necessary target properties to find it, at
# least in some contexts.  Hopefully FindSwiftXCTest sets those up in
# time.
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
find_package(SwiftXCTest REQUIRED)

fetch_hylo_dependency(SwiftArgumentParser
  GIT_REPOSITORY https://github.com/apple/swift-argument-parser.git
  GIT_TAG        1.3.0
)
