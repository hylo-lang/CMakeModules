find_package(SwiftNumerics)
include(./FetchHyloDependency)

fetch_hylo_dependency(SwiftAlgorithms
  GIT_REPOSITORY https://github.com/hylo-lang/swift-algorithms-slim
  GIT_TAG        6fcdcfea3e8f349fcc1799cf2e6a68847b306e6d
)

set_recursive_file_glob(files ${swiftalgorithms_SOURCE_DIR}/Sources/*.swift)
add_library(Algorithms ${files})
