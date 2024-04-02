include(./FetchHyloDependency)

set(swift-numerics_patch
  ${GIT_EXECUTABLE} apply ${CMAKE_CURRENT_LIST_DIR}/patches/swift-numerics.patch)

fetch_hylo_dependency(SwiftNumerics
  GIT_REPOSITORY https://github.com/apple/swift-numerics.git
  PATCH_COMMAND ${swift-numerics_patch}
  GIT_TAG        1.0.2
)
