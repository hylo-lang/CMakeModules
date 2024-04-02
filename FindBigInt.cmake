include(./FetchHyloDependency)

fetch_hylo_dependency(BigInt
  GIT_REPOSITORY https://github.com/attaswift/BigInt.git
  GIT_TAG        5.3.0
)

file(GLOB_RECURSE files FOLLOW_SYMLINKS LIST_DIRECTORIES false CONFIGURE_DEPENDS ${bigint_SOURCE_DIR}/Sources/*.swift)
add_library(BigInt ${files})
