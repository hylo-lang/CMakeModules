include(SwiftCMakeXCTesting)

add_library(DummyTestee STATIC Dummy.swift)

add_swift_xctest(XCTestBridgeTests DummyTestee Tests.swift)
