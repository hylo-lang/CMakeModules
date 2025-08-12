include(./FetchHyloDependency)

# set(patch_swift_numerics
#   ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_LIST_DIR}/scripts/GitPatch.cmake
#   ${CMAKE_CURRENT_LIST_DIR}/patches/swift-numerics.patch)

fetch_hylo_dependency(SwiftNumerics
  GIT_REPOSITORY https://github.com/tothambrus11/swift-numerics.git
  GIT_TAG        7675331540c9b0260e4638b73440c326ea9ca8c8
)
