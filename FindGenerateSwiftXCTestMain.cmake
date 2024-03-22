include_guard(GLOBAL)

include(./FetchHyloDependency)

fetch_hylo_dependency(GenerateSwiftXCTestMain
  GIT_REPOSITORY https://github.com/hylo-lang/GenerateSwiftXCTestMain.git
  GIT_TAG        main)
