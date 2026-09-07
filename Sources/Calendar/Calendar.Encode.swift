extension Calendar {
    public struct Encode {
        private let body: (Date) throws(Calendar<Date>.Encode.Error) -> DayNumber

        public init(_ body: @escaping (Date) throws(Calendar<Date>.Encode.Error) -> DayNumber) {
            self.body = body
        }
    }
}

extension Calendar.Encode {
    public func callAsFunction(_ date: Date) throws(Error) -> DayNumber {
        try body(date)
    }
}
