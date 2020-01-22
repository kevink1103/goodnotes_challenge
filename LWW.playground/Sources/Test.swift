import Foundation
import XCTest

public class LWWSetTest: XCTestCase {
    var goodnotes: LWWSet<String>!
    
    override public func setUp() {
        super.setUp()
        goodnotes = LWWSet<String>()
    }
    
    func testLookupExist() {
        goodnotes.add("Steven")
        XCTAssertTrue(goodnotes.lookup("Steven") != nil)
    }
    
    func testLookupNone() {
        XCTAssertTrue(goodnotes.lookup("Anonymous") == nil)
    }
    
    func testAdd() {
        goodnotes.add("Steven")
        XCTAssertTrue(goodnotes.lookup("Steven") != nil)
    }
    
    func testRemove() {
        goodnotes.remove("Steven")
        XCTAssertTrue(goodnotes.lookup("Steven") == nil)
    }
    
    func testReAdd() {
        goodnotes.add("Steven")
        goodnotes.remove("Steven")
        goodnotes.add("Steven")
        XCTAssertTrue(goodnotes.lookup("Steven") != nil)
    }
    
    func testAddMore() {
        goodnotes.add("Vivien")
        goodnotes.add("Kevin")
        goodnotes.add("Anonymous")
        XCTAssertTrue(goodnotes.lookup("Vivien") != nil)
        XCTAssertTrue(goodnotes.lookup("Kevin") != nil)
        XCTAssertTrue(goodnotes.lookup("Anonymous") != nil)
    }
    
    func testRemoveMore() {
        goodnotes.remove("Anonymous")
        XCTAssertTrue(goodnotes.lookup("Anonymous") == nil)
    }
    
    func testCompareSelf() {
        XCTAssertTrue(goodnotes.compare(with: goodnotes))
    }
    
    func testCompareIsSubset() {
        var temp1 = LWWSet<String>()
        temp1.add("Kim")
        temp1.add("Park")

        var temp2 = LWWSet<String>()
        temp2.add("Kim")

        XCTAssertTrue(temp2.compare(with: temp1))
    }
    
    func testCompareNotSubset() {
        var temp1 = LWWSet<String>()
        temp1.add("Kim")
        temp1.add("Park")

        var temp2 = LWWSet<String>()
        temp2.add("Kim")

        XCTAssertFalse(temp1.compare(with: temp2))
    }
    
    func testMerge() {
        var temp1 = LWWSet<String>()
        temp1.add("Kim")
        temp1.add("Park")

        var temp2 = LWWSet<String>()
        temp2.add("Lee")
        
        temp1.merge(with: temp2)
        XCTAssertTrue(temp1.lookup("Lee") != nil)
    }
}
