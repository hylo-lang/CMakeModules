include(./FetchHyloDependency)

fetch_hylo_dependency(SwiftAlgorithms
  GIT_REPOSITORY https://github.com/hylo-lang/swift-algorithms-slim
  GIT_TAG        e4d2507c1ce65dd4dd48a24979c9d0e0d02e8624
)

set_recursive_file_glob(files ${swiftalgorithms_SOURCE_DIR}/Sources/*.swift)
add_library(Algorithms ${files})
