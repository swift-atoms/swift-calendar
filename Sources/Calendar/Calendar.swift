public import Optic

public struct Calendar<Date> {
    public let correspondence: Optic<Date, Date, DayNumber, DayNumber>
        .Isomorphism.Partial<Calendar<Date>.Encode.Error, Calendar<Date>.Decode.Error>

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
