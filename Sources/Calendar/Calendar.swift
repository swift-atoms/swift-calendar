/// A correspondence between a calendar's complete dates and fixed day coordinates.
///
/// Both conversions must be inverses on the declared supported domain. Date supplies
/// its own structure and validity; this value imposes no year/month/day model.
/// Captured context must retain a stable interpretation throughout the value's use.
public struct Calendar<Date> {
    private let encode: (Date) throws(Calendar<Date>.Encode.Error) -> DayNumber
    private let decode: (DayNumber) throws(Calendar<Date>.Decode.Error) -> Date

    /// The callbacks may capture state owned by the caller's isolation region.
    public init(
        dayNumber: @escaping (Date) throws(Calendar<Date>.Encode.Error) -> DayNumber,
        date: @escaping (DayNumber) throws(Calendar<Date>.Decode.Error) -> Date
    ) {
        self.encode = dayNumber
        self.decode = date
    }
}

extension Calendar {
    public func dayNumber(of date: Date) throws(Calendar<Date>.Encode.Error) -> DayNumber {
        try encode(date)
    }

    public func date(on day: DayNumber) throws(Calendar<Date>.Decode.Error) -> Date {
        try decode(day)
    }
}
