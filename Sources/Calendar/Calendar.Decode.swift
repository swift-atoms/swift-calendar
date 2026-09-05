extension Calendar {
    /// The coordinate-to-date direction of the calendar correspondence.
    public struct Decode {
        private let body: (DayNumber) throws(Calendar<Date>.Decode.Error) -> Date

        /// Captured context remains in the caller's isolation region.
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
