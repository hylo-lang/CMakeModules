# XCTestDiscovery

A cross-platform bridge between CMake/CTest and XCTest for Swift projects.

This project has two major components:

1. A cross-platform CMake component
   [SwiftXCTestCTestBridge.cmake](https://github.com/hylo-lang/XCTestDiscovery/blob/main/cmake/SwiftXCTestCTestBridge.cmake)
   that declares an `add_swift_xctest` function.  It can be used to
   declare an XCTest target that can be run by `ctest`.
   
   ```cmake
   add_swift_xctest(${test_target} ${testee} ${test_files})
   ```

   `testee` can name an Application bundle target on macOS, but for
   cross-platform CMake code it must be a library target.  If it is a
   shared library, its `FRAMEWORK` property must be set to `TRUE`.
   
2. A tool that finds XCTest cases and test methods, and generates a
   main.swift to run them.  This functionality is built into the Swift
   Package Manager and Xcode, which is why it is needed for other
   build systems, and is not CMake-specific.  It is used automatically
   by the `add_swift_xctest` function described above when not
   building on macOS.
