import XCTest
@testable import SmartDateFormatter

final class SmartDateFormatterTests: XCTestCase {
    
    func testISO8601Parsing() {
        let isoString = "2023-10-27T10:00:00Z"
        let date = SmartDateFormatter.shared.convertStringToDate(isoString)
        XCTAssertNotNil(date, "Should parse ISO8601 string")
    }
    
    func testStandardFormatParsing() {
        let dateString = "2023-10-27"
        let date = SmartDateFormatter.shared.convertStringToDate(dateString)
        XCTAssertNotNil(date, "Should parse yyyy-MM-dd string")
    }
    
    func testSlashFormatParsing() {
        let dateString = "10/27/2023"
        let date = SmartDateFormatter.shared.convertStringToDate(dateString)
        XCTAssertNotNil(date, "Should parse MM/dd/yyyy string")
    }
    
    func testFormatConversion() {
        let original = "2023-10-27"
        let converted = SmartDateFormatter.shared.convertStringToDateAndRequiredFormat(original, requiredFormat: "dd-MM-yyyy")
        XCTAssertEqual(converted, "27-10-2023", "Should convert format correctly")
    }
    
    func testInvalidString() {
        let invalid = "Not a date"
        let date = SmartDateFormatter.shared.convertStringToDate(invalid)
        XCTAssertNil(date, "Should return nil for invalid string")
    }
    
    func testUTCConversion() {
        let dateString = "2023-10-27T12:00:00+02:00" // Noon in +2
        // Target UTC: 10:00
        let converted = SmartDateFormatter.shared.convertStringToDateAndRequiredFormatToUTC(dateString, requiredFormat: "HH:mm")
        XCTAssertEqual(converted, "10:00", "Should convert to UTC correctly")
    }
}
