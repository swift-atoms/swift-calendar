public import Time

public struct DateTime<Date> {
    public let date: Date
    public let hour: Time.Day.Hour
    public let minute: Time.Hour.Minute
    public let second: Time.Minute.Second
    public let millisecond: Time.Second.Millisecond
    public let microsecond: Time.Millisecond.Microsecond
    public let nanosecond: Time.Microsecond.Nanosecond

    public init(
        date: Date,
        hour: Time.Day.Hour = .zero,
        minute: Time.Hour.Minute = .zero,
        second: Time.Minute.Second = .zero,
        millisecond: Time.Second.Millisecond = .zero,
        microsecond: Time.Millisecond.Microsecond = .zero,
        nanosecond: Time.Microsecond.Nanosecond = .zero
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

extension DateTime: Swift.Sendable where Date: Swift.Sendable {}

extension DateTime: Swift.Equatable where Date: Swift.Equatable {}

extension DateTime: Swift.Hashable where Date: Swift.Hashable {}

extension DateTime {
    public var totalNanoseconds: Int {
        Time.totalNanoseconds(millisecond: millisecond, microsecond: microsecond, nanosecond: nanosecond)
    }
}
