include(./FetchHyloDependency)

set(patch_swift_collections
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/scripts/GitPatch.cmake
  ${CMAKE_CURRENT_LIST_DIR}/patches/swift-collections.patch)

fetch_hylo_dependency(SwiftCollections
  GIT_REPOSITORY https://github.com/apple/swift-collections.git
  PATCH_COMMAND ${patch_swift_collections}
  GIT_TAG        1.0.6
)
