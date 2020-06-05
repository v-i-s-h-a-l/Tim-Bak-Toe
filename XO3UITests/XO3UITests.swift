//
//  XO3UITests.swift
//  XO3UITests
//
//  Created by Vishal Singh on 05/06/20.
//  Copyright © 2020 v-i-s-h-a-l. All rights reserved.
//

import XCTest

class XO3UITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHostWin() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.

        app.buttons["Play Now"].tap()
        let boardCell00 = GSE.boardCell(0, 0).findIn(app: app)
        _ = boardCell00.waitForExistence(timeout: 0.5)

        for index in 0..<3 {
            let hostPiece = GSE.hostPiece(index).findIn(app: app)
            let hostBoardCell = GSE.boardCell(2, index).findIn(app: app)
            hostPiece.press(forDuration: 0.01, thenDragTo: hostBoardCell)
//            expectPiecesHittability(piece: GSE.hostPiece(index), in: app)

            let peerPiece = GSE.peerPiece(index).findIn(app: app)
            let peerBoardCell = GSE.boardCell(1, index).findIn(app: app)
            if peerPiece.isHittable {
                peerPiece.press(forDuration: 0.01, thenDragTo: peerBoardCell)
//                expectPiecesHittability(piece: GSE.peerPiece(index), in: app)
            }
        }
    }
    
    fileprivate func expectPiecesHittability(piece: GSE, in app: XCUIApplication) {
        switch piece {
        case .hostPiece:
            for index in 0..<3 {
                let hostPiece = GSE.hostPiece(index).findIn(app: app)
                XCTAssertFalse(hostPiece.isHittable, "Host piece \(index) should not be hittable.")
                let peerPiece = GSE.peerPiece(index).findIn(app: app)
                XCTAssertTrue(peerPiece.isHittable, "Peer piece \(index) should be hittable")
            }

        case .peerPiece:
            for index in 0..<3 {
                let hostPiece = GSE.hostPiece(index).findIn(app: app)
                XCTAssertTrue(hostPiece.isHittable, "Host piece \(index) should be hittable.")
                let peerPiece = GSE.peerPiece(index).findIn(app: app)
                XCTAssertFalse(peerPiece.isHittable, "Peer piece \(index) should not be hittable")
            }
        case .boardCell: break
        }
        
    }
    

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}

enum GSE { // stands for game screen element
    case hostPiece(Int)
    case peerPiece(Int)
    case boardCell(Int, Int)
    
    var identifier: String {
        switch self {
        case .hostPiece(let index): return "HostPiece\(index)"
        case .peerPiece(let index): return "PeerPiece\(index)"
        case .boardCell(let row, let column): return "BoardCell\(row)\(column)"
        }
    }

    func findIn(app: XCUIApplication) -> XCUIElement {
        return app.otherElements[identifier]
    }
}
