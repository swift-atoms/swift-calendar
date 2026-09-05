public import Affine
internal import Difference
public import Tagged

/// A Rata Die calendar coordinate: day 1 is proleptic Gregorian 0001-01-01.
/// This coordinate is independent of a physical instant or a time-zone boundary.
public struct DayNumber {
    private let position: Affine.Position<DayNumber>

    public init(rawValue: Int64) {
        position = Affine.Position(rawValue: rawValue)
    }
}

extension DayNumber {
    public typealias Offset = Affine.Position<DayNumber>.Offset

    public var rawValue: Int64 { position.rawValue }

    public func advanced(by offset: Offset) throws(DayNumber.Error) -> Self {
        do { return Self(rawValue: try position.advanced(by: offset).rawValue) }
        catch { throw .overflow }
    }

    public func adding(_ days: Int64) throws(DayNumber.Error) -> Self {
        try advanced(by: Offset(Difference(Int(days))))
    }

    /// Every pair of Int64 day coordinates has a representable signed difference.
    public func distance(to other: Self) -> Offset {
        position.distance(to: other.position)
    }

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.position < rhs.position
    }

    public static func + (lhs: Self, rhs: Offset) throws(DayNumber.Error) -> Self {
        try lhs.advanced(by: rhs)
    }

    public static func - (lhs: Self, rhs: Self) -> Offset {
        rhs.distance(to: lhs)
    }
}

extension DayNumber: RawRepresentable {}
extension DayNumber: Sendable {}
extension DayNumber: Hashable {}
extension DayNumber: Comparable {}
