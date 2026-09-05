public import Time

/// A calendar date composed with the existing temporal component types.
public struct DateTime<Date> {
    public let date: Date
    public let hour: Time.Hour
    public let minute: Time.Minute
    public let second: Time.Second
    public let millisecond: Time.Millisecond
    public let microsecond: Time.Microsecond
    public let nanosecond: Time.Nanosecond

    public init(
        date: Date,
        hour: Time.Hour = .zero,
        minute: Time.Minute = .zero,
        second: Time.Second = .zero,
        millisecond: Time.Millisecond = .zero,
        microsecond: Time.Microsecond = .zero,
        nanosecond: Time.Nanosecond = .zero
    ) {
        self.date = date
        self.hour = hour
        self.minute = minute
        self.second = second
        self.millisecond = millisecond
        self.microsecond = microsecond
        self.nanosecond = nanosecond
    }
}

extension DateTime: Sendable where Date: Sendable {}
extension DateTime: Equatable where Date: Equatable {}
extension DateTime: Hashable where Date: Hashable {}

extension DateTime {
    public var totalNanoseconds: Int {
        Time.totalNanoseconds(millisecond: millisecond, microsecond: microsecond, nanosecond: nanosecond)
    }
}
