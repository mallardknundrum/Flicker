//
//  FlickerTests.swift
//  FlickerTests
//
//  Created by Jeremiah Hawks on 1/28/18.
//  Copyright © 2018 Jeremiah Hawks. All rights reserved.
//

import XCTest
@testable import Flicker

class FlickerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPhotoMetaDataInit() {
        let json = getJson()
        guard let _ = PhotoMetaData(jsonDictionary: json) else { assertionFailure("initializer failed"); return }
    }
    
    func getJson() -> [String: Any] {
        guard let bundlePath = Bundle.main.path(forResource: "TestJson", ofType: "json"),
            let data = ( try? Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .alwaysMapped)),
        let json = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
            else { return [:] }
        return json
    }
    
}
