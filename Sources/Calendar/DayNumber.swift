public import Coordinate
public import Difference
public import Tagged
internal import Cardinal
internal import Magnitude
internal import Polarity

public struct DayNumber {
    private let position: Coordinate<1, Int64>

    public init(rawValue: Int64) { position = Coordinate(rawValue: rawValue) }
}

extension DayNumber {
    public typealias Offset = Tagged<DayNumber, Difference>
    public var rawValue: Int64 { position.rawValue }

    private static func displacement(from start: Self, to end: Self) -> Offset {
        let delta = Int128(end.rawValue) - Int128(start.rawValue)
        return Offset(_unchecked: Difference(
            polarity: delta < 0 ? .negative : .positive,
            magnitude: Difference.Magnitude(Cardinal(UInt(delta.magnitude)))
        ))
    }

    public func advanced(by offset: Offset) throws(Error) -> Self {
        let value = offset.underlying
        let magnitude = Int128(value.magnitude.value.rawValue)
        let delta = value.polarity == .negative ? -magnitude : magnitude
        guard let result = Int64(exactly: Int128(rawValue) + delta) else { throw .overflow }
        return Self(rawValue: result)
    }

    public func adding(_ days: Int64) throws(Error) -> Self {
        let magnitude = UInt(days.magnitude)
        let delta = Difference(
            polarity: days < 0 ? .negative : .positive,
            magnitude: Difference.Magnitude(Cardinal(magnitude))
        )
        return try advanced(by: Offset(_unchecked: delta))
    }

    public func distance(to other: Self) -> Offset { Self.displacement(from: self, to: other) }
    public static func < (lhs: Self, rhs: Self) -> Bool { lhs.rawValue < rhs.rawValue }
    public static func + (lhs: Self, rhs: Offset) throws(Error) -> Self { try lhs.advanced(by: rhs) }
    public static func - (lhs: Self, rhs: Self) -> Offset { rhs.distance(to: lhs) }
}

extension DayNumber: Swift.Sendable {}
extension DayNumber: Swift.Hashable {}
