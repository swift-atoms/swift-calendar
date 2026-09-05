extension Calendar {
    /// The date-to-coordinate direction of the calendar correspondence.
    public struct Encode {
        private let body: (Date) throws(Calendar<Date>.Encode.Error) -> DayNumber

        /// Captured context remains in the caller's isolation region.
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
