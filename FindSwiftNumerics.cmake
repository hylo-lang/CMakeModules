include(./FetchHyloDependency)

set(patch_swift_numerics
  ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/scripts/GitPatch.cmake
  ${CMAKE_CURRENT_LIST_DIR}/patches/swift-numerics.patch)

fetch_hylo_dependency(SwiftNumerics
  GIT_REPOSITORY https://github.com/apple/swift-numerics.git
  PATCH_COMMAND ${patch_swift_numerics}
  GIT_TAG        1.0.2
)
