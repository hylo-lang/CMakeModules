# SwiftCMakeXCTesting

A cross-platform bridge between CMake/CTest and XCTest for Swift projects.

1. A cross-platform CMake component
   [SwiftCMakeXCTesting.cmake](https://github.com/hylo-lang/SwiftCMakeXCTesting/blob/main/cmake/SwiftCMakeXCTesting.cmake)
   that declares an `add_swift_xctest` function.  It can be used to
   declare an XCTest target that can be run by `ctest`.
   
   ```cmake
   add_swift_xctest(${test_target} ${testee} ${test_files})
   ```

   `testee` can name an Application bundle target on macOS, but for
   cross-platform CMake code it must be a library target.  If it is a
   shared library, its `FRAMEWORK` property must be set to `TRUE`.

## Dependency

On non-apple platforms, uses [GenerateSwiftXCTestMain](https://github.com/hylo-lang/GenerateSwiftXCTestMain).
