import XCTest
@testable import SpyApp

class RailfenceCipherTests: XCTestCase {
    var cipher: Cipher!
    
    override func setUp() {
        super.setUp()
        cipher = RailfenceCipher()
    }
    
    // Invalid Validation Unit Tests
    func test_emptyCipherText() {
        let encodeResult = cipher.encode("", secret: "2")
        let decodeResult = cipher.decode("", secret: "2")
        XCTAssertEqual("Please Enter Cipher Text", encodeResult)
        XCTAssertEqual("Please Enter Cipher Text", decodeResult)
    }
    
    func test_emptySecret() {
        let encodeResult = cipher.encode("Test", secret: "")
        let decodeResult = cipher.decode("Test", secret: "")
        XCTAssertEqual("Please Enter Cipher Key", encodeResult)
        XCTAssertEqual("Please Enter Cipher Key", decodeResult)
    }
    
    func test_nonNumericInputForSecret() {
        let encodeResult = cipher.encode("Test", secret: "A")
        let decodeResult = cipher.decode("Test", secret: "A")
        XCTAssertEqual("Please Enter Valid Cipher Key", encodeResult)
        XCTAssertEqual("Please Enter Valid Cipher Key", decodeResult)
    }
    
    func test_secretKeyValueTooSmall() {
        let encodeResult = cipher.encode("Test", secret: "1")
        let decodeResult = cipher.decode("Test", secret: "1")
        XCTAssertEqual("Please Enter Cipher Key Greater Than 1", encodeResult)
        XCTAssertEqual("Please Enter Cipher Key Greater Than 1", decodeResult)
    }
    
    // Encoding Unit Tests
    func test_encodingAlgorithmWithMultipleSecrets() {
        let result0 = cipher.encode("Hello World", secret: "2")
        XCTAssertEqual("HloolelWrd", result0)
        
        let result1 = cipher.encode("Hello World", secret: "3")
        XCTAssertEqual("HolelWrdlo", result1)
        
        let result2 = cipher.encode("Hello World", secret: "4")
        XCTAssertEqual("HoeWrlolld", result2)
        
        let result3 = cipher.encode("Hello World", secret: "5")
        XCTAssertEqual("HlerdlolWo", result3)
    }
    
    // Decoding Unit Tests
    func test_decodingAlgorithmWithMultipleSecrets() {
        let result0 = cipher.decode("HloyaesoetelMNmIRbr", secret: "2")
        XCTAssertEqual("HelloMyNameIsRobert", result0)
        
        let result1 = cipher.decode("acmitaktingttadh", secret: "3")
        XCTAssertEqual("attackatmidnight", result1)
        
        let result2 = cipher.decode("idganonrmifuykh", secret: "4")
        XCTAssertEqual("iamkindofhungry", result2)
        
        let result3 = cipher.decode("TlhlFaAotsls'k", secret: "5")
        XCTAssertEqual("That'sAllFolks", result3)
    }
}

