find_package(SwiftXCTest REQUIRED)

add_library(XCTestImporter XCTestImporter.swift)
target_link_libraries(XCTestImporter SwiftXCTest)

add_library(DummyTestee STATIC Dummy.swift)

add_swift_xctest(XCTestBridgeTests DummyTestee Tests.swift)
