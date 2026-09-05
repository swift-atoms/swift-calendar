/// An integer coordinate under the Rata Die fixed-day convention:
/// day 1 is proleptic Gregorian 0001-01-01; day 0 is its predecessor.
///
/// This is a calendar coordinate, not an instant or an elapsed duration. Adapters
/// must agree on the convention; physical day boundaries and zones are separate.
public struct DayNumber {
    public let rawValue: Int64

    public init(rawValue: Int64) { self.rawValue = rawValue }
}

extension DayNumber {
    public func adding(_ days: Int64) throws(DayNumber.Error) -> Self {
        let (value, overflow) = rawValue.addingReportingOverflow(days)
        guard !overflow else { throw .overflow }
        return Self(rawValue: value)
    }

    public func distance(to other: Self) throws(DayNumber.Error) -> Int64 {
        let (value, overflow) = other.rawValue.subtractingReportingOverflow(rawValue)
        guard !overflow else { throw .overflow }
        return value
    }

    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
}

extension DayNumber: RawRepresentable {}
extension DayNumber: Sendable {}
extension DayNumber: Hashable {}
extension DayNumber: Comparable {}
