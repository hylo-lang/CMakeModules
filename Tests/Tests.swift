import XCTest
import DummyTestee

final class TestCase: XCTestCase {

  func test1() {
  }

  private func test() {
    XCTFail("This shouldn't run")
  }

  static func testStaticMethodsAreNotTests() {
    XCTFail("This shouldn't run")
  }

}

extension TestCase {

  func testExtensionMethodsCanBeTests() {}

}

struct StructsAreNotTestCases {

  func testStructMethodsAreNotTests() {
    XCTFail("This shouldn't run")
  }

  class NestedStructClassesCanBeTestCases: XCTestCase {

    func testNestedClassMethodsCanBeTests() {}

  }

}

enum EnumsAreNotTestCases {

  func testEnumMethodsAreNotTests() {
    XCTFail("This shouldn't run")
  }

  class NestedEnumClassesCanBeTestCases: XCTestCase {

    func testNestedClassMethodsCanBeTests() {}

  }

}

extension StructsAreNotTestCases {

  func testStructExtensionMethodsAreNotTests() {
    XCTFail("This shouldn't run")
  }

}

class NotAllClassesAreTestCases {

  func testNonXCTestCaseMethodsAreNotTests() {
    XCTFail("This shouldn't run")
  }

}
