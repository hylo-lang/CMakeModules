find_package(XCTest)

# Adds the XCTest target.
function(_FindSwiftXCTest_add_XCTest)
  if(APPLE)
    _FindSwiftXCTest_add_XCTest_apple()
  elseif(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
    _FindSwiftXCTest_add_XCTest_windows()
  else()
    _FindSwiftXCTest_add_XCTest_unknown_host()
  endif()
endfunction()

# Uses the Apple-only support in FindXCTest to create the XCTest library.
function(_FindSwiftXCTest_add_XCTest_apple)
  if(NOT XCTest_FOUND)
    message(FATAL_ERROR "XCTest is required, but was not found.")
  endif()
  add_library(XCTest INTERFACE) # the Objective-C XCTest module
  target_link_libraries(XCTest INTERFACE ${XCTest_LIBRARIES})
endfunction()

# Adds the XCTest library using the same logic as Swift Package
# Manager uses.
function(_FindSwiftXCTest_add_XCTest_windows)

  add_library(XCTest SHARED IMPORTED)
  #
  # Logic lifted from
  # https://github.com/apple/swift-package-manager/blob/e10ff906c/Sources/PackageModel/UserToolchain.swift#L361-L447
  # with thanks to @compnerd. The code is ugly, but it intentionally
  # matches the structure from Swift Package Manager to make it easy
  # to maintain the correspondence.
  #
  cmake_path(CONVERT $ENV{SDKROOT} TO_CMAKE_PATH_LIST sdkroot NORMALIZE)
  if(${sdkroot} MATCHES ".*/$") # CMake is nutty about trailing slashes; strip any that are there.
    cmake_path(GET sdkroot PARENT_PATH sdkroot)
  endif()

  cmake_path(GET sdkroot PARENT_PATH platform)
  cmake_path(GET platform PARENT_PATH platform)
  cmake_path(GET platform PARENT_PATH platform)

  # Crude XML parsing to find the xctest version
  file(READ ${platform}/Info.plist plistXML)
  string(REGEX REPLACE ".*<key>XCTEST_VERSION</key>[ \t\r\n]*<string>([^<]+)</string>.*" "\\1" xctestVersion "${plistXML}")

  if(${CMAKE_SYSTEM_PROCESSOR} STREQUAL "ARM64")
    set(archName aarch64)
    set(archBin bin64a)
  elseif(${CMAKE_SYSTEM_PROCESSOR} MATCHES "AMD64|IA64|EM64T|x64")
    set(archName x86_64)
    set(archBin bin64)
  else()
    set(archName i686)
    set(archBin bin32)
  endif()

  cmake_path(APPEND platform Developer Library XCTest-${xctestVersion} OUTPUT_VARIABLE installation)

  target_include_directories(XCTest INTERFACE "${installation}/usr/lib/swift/windows")

  # Migration Path
  #
  # Older Swift (<=5.7) installations placed the XCTest Swift module into the architecture specified
  # directory in order to match the SDK setup.
  target_include_directories(XCTest INTERFACE
    "${installation}/usr/lib/swift/windows/${archName}"
  )
  target_link_directories(XCTest INTERFACE
    "${installation}/usr/lib/swift/windows/${archName}"
  )

  set_target_properties(XCTest PROPERTIES
    # There's no analogy for this in the Swift code but CMake insists on it.
    IMPORTED_IMPLIB "${installation}/usr/lib/swift/windows/${archName}/XCTest.lib"

    # This doesn't seem to have any effect on its own, but it needs to be in the the PATH in order
    # to run the test executable.
    IMPORTED_LOCATION "${installation}/usr/${archBin}/XCTest.dll"
  )

  # Migration Path
  #
  # Before multiple parallel SDK installations were supported (~5.7), we always had a singular
  # installed SDK.  Add it as a fallback if it exists.
  set(implib "${installation}/usr/lib/swift/windows/XCTest.lib")
  if(EXISTS ${implib})
    cmake_path(GET implib PARENT_PATH p)
    target_link_directories(XCTest INTERFACE ${p})
  endif()

endfunction()

# Adds the XCTest library target using the normal logic for
# pre-installed libraries.
function(_FindSwiftXCTest_add_XCTest_unknown_host)
  find_library(
    XCTest_LIBRARY
    NAMES XCTest
    DOC "XCTest library")
endfunction()

# If APPLE_PLATFORM_DEVELOPER_DIRECTORY is unset, sets it to the
# .../<Platform>.platform/Developer directory of Swift's target
# platform in the current Swift toolchain, or exits with a fatal error
# if that directory can't be found.
#
# Requires: ${APPLE}
function(_FindSwiftXCTest_apple_swift_Platform_Developer_directory)
  if(DEFINED APPLE_PLATFORM_DEVELOPER_DIRECTORY)
    return()
  endif()

  set(platform_developer "")
  foreach(d ${CMAKE_Swift_IMPLICIT_INCLUDE_DIRECTORIES})
    if(${d} MATCHES "^(.*[.]platform/Developer)/SDKs/.*")
      string(REGEX REPLACE "^(.*[.]platform/Developer)/SDKs/.*" "\\1" platform_developer ${d})
      break()
    endif()
  endforeach()

  if(${platform_developer} STREQUAL "")
    set(platform_developer "APPLE_PLATFORM_DEVELOPER_DIRECTORY-NOTFOUND")
  endif()

  set(APPLE_PLATFORM_DEVELOPER_DIRECTORY
    "${platform_developer}" CACHE PATH
    "The .../<Platform>.platform/Developer directory of Swift's target platform in the current Swift toolchain.")

  if(NOT APPLE_PLATFORM_DEVELOPER_DIRECTORY)
    message(FATAL_ERROR
      "failed to find platform developer directory in ${CMAKE_Swift_IMPLICIT_INCLUDE_DIRECTORIES}")
  endif()

endfunction()

# Adds the swift-only SwiftXCTest target.
#
# - Precondition: the XCTest target exists
function(_FindSwiftXCTest_add_SwiftXCTest)
  add_library(SwiftXCTest INTERFACE)
  target_link_libraries(SwiftXCTest INTERFACE XCTest)

  if(APPLE)
    _FindSwiftXCTest_apple_swift_Platform_Developer_directory(platform_developer)

    # Where to find the XCTestSwiftSupport.swiftmodule
    target_include_directories(SwiftXCTest
      INTERFACE ${APPLE_PLATFORM_DEVELOPER_DIRECTORY}/usr/lib/)
    # Where to find libXCTestSwiftSupport.dylib
    set_target_properties(SwiftXCTest
      PROPERTIES INTERFACE_LINK_DIRECTORIES ${APPLE_PLATFORM_DEVELOPER_DIRECTORY}/usr/lib)
  endif()
endfunction()

# add_swift_xctest(
#   <name> <testee>
#   <swift_source> ...
#   DEPENDENCIES <target> ...
# )
#
# Creates a CTest test target named `<name>`, testing `<testee>`, that runs the tests in the given
# Swift source files.
#
# On Apple platforms, `<testee>` must be a target type supported by `xctest_add_bundle` (officially,
# Frameworks and App Bundles, although static modules seem to work also).  On other platforms
# `<testee>` can be any target type that works as a dependency in `target_link_libraries`.
function(add_swift_xctest test_target testee)

  cmake_parse_arguments(ARG "" "" "DEPENDENCIES" ${ARGN})
  set(sources ${ARG_UNPARSED_ARGUMENTS})
  set(dependencies ${ARG_DEPENDENCIES})

  if(APPLE)
  
    if(NOT XCTest_FOUND)
      message(FATAL_ERROR "XCTest is required, but was not found.")
    endif()
    xctest_add_bundle(${test_target} ${testee} ${sources})
    target_link_libraries(${test_target} PRIVATE SwiftXCTest ${dependencies})
    xctest_add_test(XCTest.${test_target} ${test_target})

  else()

    set(test_main "${PROJECT_BINARY_DIR}/${test_target}-test_main/main.swift")
    add_custom_command(
      OUTPUT ${test_main}
      # If the executable target depends on DLLs their directories need to be injected into the PATH
      # or they won't be found and the target will fail to run, so invoke it through cmake.  Because
      COMMAND
        ${CMAKE_COMMAND} -E env
        "PATH=$<SHELL_PATH:$<TARGET_RUNTIME_DLL_DIRS:GenerateXCTestMain>;$ENV{PATH}>"
        --
        $<TARGET_FILE:GenerateXCTestMain> -o ${test_main} ${sources}
      DEPENDS ${sources} GenerateXCTestMain
      WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
      COMMENT "Generate runner for test target ${test_target}")

    add_executable(${test_target} ${test_main} ${sources})

    target_link_libraries(${test_target} PRIVATE ${testee} SwiftXCTest ${dependencies})

    add_test(NAME ${test_target}
      COMMAND ${test_target})

    set_tests_properties(${test_target}
      PROPERTIES ENVIRONMENT_MODIFICATION
      # For each DLL dependency X, make the PATH=path_list_prepend:X environment modification.
      "$<LIST:TRANSFORM,$<TARGET_RUNTIME_DLL_DIRS:${test_target}>,PREPEND,PATH=path_list_prepend:>")

  endif()

endfunction()

_FindSwiftXCTest_add_XCTest()
_FindSwiftXCTest_add_SwiftXCTest()
