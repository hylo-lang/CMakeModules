find_package(SwiftNumerics)
include(./FetchHyloDependency)

fetch_hylo_dependency(SwiftAlgorithms
  GIT_REPOSITORY https://github.com/apple/swift-algorithms.git
  GIT_TAG        1.2.0
)

set_recursive_file_glob(files ${swiftalgorithms_SOURCE_DIR}/Sources/*.swift)
add_library(Algorithms ${files})
target_link_libraries(Algorithms PRIVATE RealModule)
