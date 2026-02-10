
import Foundation

public final class SmartDateFormatter: Sendable {
    
    public static let shared = SmartDateFormatter()
    
    /// List of format strings that strict date formatters will attempt to use.
    public let allowedFormats: [String]
    
    public init(allowedFormats: [String] = [
        "yyyy-MM-dd'T'HH:mm:ssZ",
        "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
        "yyyy-MM-dd",
        "dd-MM-yyyy",
        "MM/dd/yyyy HHmm",
        "MM/dd/yyyy",
        "dd/MM/yyyy",
        "MMM d, yyyy",
        "d MMM yyyy",
        "E, d MMM yyyy HH:mm:ss Z"
    ]) {
        self.allowedFormats = allowedFormats
    }
    
    /// Attempts to convert a date string into a Date object by trying multiple formats.
    /// - Parameter dateString: The date string to parse.
    /// - Returns: A valid Date object if parsing succeeds, otherwise nil.
    public func convertStringToDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        for format in allowedFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        // Fallback: ISO8601DateFormatter for standard ISO strings which can be tricky with regular DateFormatter
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        
        return nil
    }
    
    /// Converts a date string from an unknown format to a target format.
    /// - Parameters:
    ///   - dateString: The original date string.
    ///   - requiredFormat: The desired output format string.
    ///   - timeZone: The target time zone (default: .current).
    /// - Returns: The formatted date string, or nil if parsing fails.
    public func convertStringToDateAndRequiredFormat(_ dateString: String, requiredFormat: String, timeZone: TimeZone = .current) -> String? {
        guard let date = convertStringToDate(dateString) else { return nil }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = timeZone
        formatter.dateFormat = requiredFormat
        return formatter.string(from: date)
    }
    
    /// Converts a date string to a UTC string with a specified format.
    public func convertStringToDateAndRequiredFormatToUTC(_ dateString: String, requiredFormat: String) -> String? {
        return convertStringToDateAndRequiredFormat(dateString, requiredFormat: requiredFormat, timeZone: TimeZone(secondsFromGMT: 0)!)
    }
    
    /// Convenience method to formatting a Date object directly
    public func string(from date: Date, format: String) -> String {
         let formatter = DateFormatter()
         formatter.dateFormat = format
         return formatter.string(from: date)
    }
}
