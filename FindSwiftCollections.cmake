include(./FetchHyloDependency)

set(patch_swift_collections
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/scripts/GitPatch.cmake
  ${CMAKE_CURRENT_LIST_DIR}/patches/swift-collections.patch)

fetch_hylo_dependency(SwiftCollections
  GIT_REPOSITORY https://github.com/hylo-lang/swift-collections
  GIT_TAG        88ae722271e83dc3a22be45b36c7467a02c69292
)
