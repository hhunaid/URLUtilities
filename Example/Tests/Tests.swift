import UIKit
import XCTest
import URLUtilities

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testQueryDictionary() {
        let url = URL(string:"http://www.google.com?q=query&p=path")!
        let dict = url.queryDictionary
        XCTAssertNotNil(dict)
        XCTAssertEqual(dict!, ["q":"query", "p":"path"])
    }
    
    func testQueryDictionaryNil() {
        let url = URL(string:"http://www.google.com")!
        XCTAssertNil(url.queryDictionary)
    }
    
    func testReplacingQueryDictionary() {
        var url = URL(string:"http://www.google.com?q=query&p=path")!
        url.replace(queryDictionary: ["q":"path", "p":"query"])
        XCTAssertEqual(url.absoluteString, "http://www.google.com?q=path&p=query")
    }
    
    func testAppendingQueryDictionary() {
        var url = URL(string:"http://www.google.com?q=query&p=path")!
        url.append(queryDictionary: ["foo":"bar","baz":"foo"])
        XCTAssertEqual(url.queryDictionary!, ["q":"query", "p":"path", "foo":"bar","baz":"foo"])
    }
    
    func testRemovingQuery() {
        let url = URL(string:"http://www.google.com?q=query&p=path")!
        XCTAssertNil(url.removingQueryParameters.queryDictionary)
    }
    
    func testInitializer() {
        let url = URL(string:"http://www.google.com", queryDictionary:["q":"query", "p":"path"])!
        XCTAssertEqual(url.absoluteString, "http://www.google.com?q=query&p=path")
    }
}
