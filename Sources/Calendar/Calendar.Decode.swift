extension Calendar {
    public struct Decode {
        private let body: (DayNumber) throws(Calendar<Date>.Decode.Error) -> Date

        public init(_ body: @escaping (DayNumber) throws(Calendar<Date>.Decode.Error) -> Date) {
            self.body = body
        }
    }
}

extension Calendar.Decode {
    public func callAsFunction(_ day: DayNumber) throws(Error) -> Date {
        try body(day)
    }
}
