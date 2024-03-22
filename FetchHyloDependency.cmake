include_guard(GLOBAL)

include(FetchContent)

macro(fetch_hylo_dependency)

  block()
    set(FETCHCONTENT_TRY_FIND_PACKAGE_MODE OPT_IN)
    FetchContent_Declare(${ARGV} OVERRIDE_FIND_PACKAGE)
  endblock()

  # Not using block() here because FetchContent_MakeAvailable typically causes dependency-specific
  # global variables to be set, and I'm not sure to what extent they may be needed
  if(YES)
    set(saved_BUILD_EXAMPLES ${BUILD_EXAMPLES})
    set(saved_BUILD_TESTING ${BUILD_TESTING})

    set(BUILD_EXAMPLES NO)
    set(BUILD_TESTING NO)

    FetchContent_MakeAvailable(${ARGV0})

    set(BUILD_EXAMPLES ${saved_BUILD_EXAMPLES})
    set(BUILD_TESTING ${saved_BUILD_TESTING})
  endif()

endmacro()
