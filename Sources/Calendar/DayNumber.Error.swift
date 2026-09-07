extension DayNumber {
    /// The result cannot be represented by the fixed-day coordinate's Int64 storage.
    public enum Error {
        case overflow
    }
}

extension DayNumber.Error: Swift.Equatable {}

extension DayNumber.Error: Swift.Error {}
