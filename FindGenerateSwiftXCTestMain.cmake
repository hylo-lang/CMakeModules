include_guard(GLOBAL)

include(./FetchHyloDependency)

fetch_hylo_dependency(GenerateSwiftXCTestMain
  GIT_REPOSITORY https://github.com/hylo-lang/GenerateSwiftXCTestMain.git
  GIT_TAG        63645fca3779f927c62b6fff1202963672d8c4bc)
