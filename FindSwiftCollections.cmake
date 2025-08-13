include(./FetchHyloDependency)

set(patch_swift_collections
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/scripts/GitPatch.cmake
  ${CMAKE_CURRENT_LIST_DIR}/patches/swift-collections.patch)

fetch_hylo_dependency(SwiftCollections
  GIT_REPOSITORY https://github.com/tothambrus11/swift-collections.git
  GIT_TAG        965b519eceb31f6c1ce1408c5ee1a65745e2379f
)
