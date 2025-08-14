include(./FetchHyloDependency)

# ArgumentParser relies on XCTest even in its non-test code and it
# seems not to have the necessary target properties to find it, at
# least in some contexts.  Hopefully FindSwiftXCTest sets those up in
# time.
list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
find_package(SwiftXCTest REQUIRED)

set(patch_swift_argument_parser
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/scripts/GitPatch.cmake
  ${CMAKE_CURRENT_LIST_DIR}/patches/swift-argument-parser.patch)

fetch_hylo_dependency(SwiftArgumentParser
  GIT_REPOSITORY https://github.com/tothambrus11/swift-argument-parser
  GIT_TAG        ec6de6b76437a2558f43eee670def20f03b82f5f
)
