public import Optic

/// A correspondence between a calendar's complete dates and fixed day coordinates.
///
/// Both conversions must be inverses on the declared supported domain. Date supplies
/// its own structure and validity; this value imposes no year/month/day model.
/// Captured context must retain a stable interpretation throughout the value's use.
public struct Calendar<Date> {
    public let correspondence: Optic<Date, Date, DayNumber, DayNumber>
        .Isomorphism.Partial<Calendar<Date>.Encode.Error, Calendar<Date>.Decode.Error>

    /// The directions must be inverses wherever either direction succeeds.
    ///
    /// Successful encoding must produce a decodable coordinate, and successful
    /// decoding must produce an encodable date. Each round trip preserves the
    /// original date or coordinate. Date equality is semantic and does not
    /// require an Equatable conformance.
    public init(
        encode: Calendar<Date>.Encode,
        decode: Calendar<Date>.Decode
    ) {
        self.correspondence = .init(
            forward: { date throws(Calendar<Date>.Encode.Error) in try encode(date) },
            backward: { day throws(Calendar<Date>.Decode.Error) in try decode(day) }
        )
    }
}

extension Calendar {
    public var encode: Encode { .init(correspondence.forward) }

    public var decode: Decode { .init(correspondence.backward) }

    /// Creates both directions from callbacks in the caller's isolation region.
    ///
    /// The callbacks must satisfy the inverse laws of `init(encode:decode:)`.
    public init(
        dayNumber: @escaping (Date) throws(Calendar<Date>.Encode.Error) -> DayNumber,
        date: @escaping (DayNumber) throws(Calendar<Date>.Decode.Error) -> Date
    ) {
        self.init(encode: .init(dayNumber), decode: .init(date))
    }

    public func dayNumber(of date: Date) throws(Calendar<Date>.Encode.Error) -> DayNumber {
        try correspondence.forward(date)
    }

    public func date(on day: DayNumber) throws(Calendar<Date>.Decode.Error) -> Date {
        try correspondence.backward(day)
    }
}
