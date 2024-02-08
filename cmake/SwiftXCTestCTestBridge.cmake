if(APPLE)
  include(FindXCTest)
  add_library(XCTest SHARED IMPORTED)

  # Determine the .../<Platform>.platform/Developer directory prefix where XCTest can be found.
  # TODO: the directories derived from this should probably have a CMakeCache entry.
  set(platform_developer "")
  foreach(d ${CMAKE_Swift_IMPLICIT_INCLUDE_DIRECTORIES})
    if(${d} MATCHES "^(.*[.]platform/Developer)/SDKs/.*")
      string(REGEX REPLACE "^(.*[.]platform/Developer)/SDKs/.*" "\\1" platform_developer ${d})
      break()
    endif()
  endforeach()
  if(${platform_developer} STREQUAL "")
    message(FATAL_ERROR "failed to find platform developer directory in ${CMAKE_Swift_IMPLICIT_INCLUDE_DIRECTORIES}")
  endif()

  target_include_directories(XCTest INTERFACE ${platform_developer}/usr/lib/)
  set_target_properties(XCTest PROPERTIES
    IMPORTED_LOCATION ${platform_developer}/usr/lib/libXCTestSwiftSupport.dylib)
else()
  find_package(XCTest CONFIG QUIET)
endif()

# add_swift_xctest(
#   <NAME>
#   <SWIFT_SOURCE> ...
#   DEPENDENCIES <Target> ...
# )
#
# Create a CTest test named <NAME> that runs the tests in the given
# Swift source files.
function(add_swift_xctest test_target testee)

  cmake_parse_arguments(ARG "" "" "DEPENDENCIES" ${ARGN})
  set(sources ${ARG_UNPARSED_ARGUMENTS})
  set(dependencies ${ARG_DEPENDENCIES})

  if(APPLE)

    message("sources= ${sources}")
    xctest_add_bundle(${test_target} ${testee} ${sources})
    target_link_libraries(${test_target} PRIVATE XCTest ${dependencies})
    xctest_add_test(XCTest.${test_target} ${test_target})

  else()

    find_package(XCTest CONFIG QUIET)

    set(test_main ${PROJECT_BINARY_DIR}/${test_target}-test_main/main.swift)
    add_custom_command(
      OUTPUT ${test_main}
      COMMAND generate-xctest-main -o ${test_main} ${sources}
      DEPENDS ${sources} generate-xctest-main
      COMMENT "Generate runner for test target ${test_target}")

    add_executable(${test_target} ${test_main} ${sources})

    target_link_libraries(${test_target} PRIVATE ${testee} XCTest ${dependencies})

    add_test(NAME ${test_target}
      COMMAND ${test_target})

  endif()

endfunction()
