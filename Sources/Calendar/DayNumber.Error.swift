extension DayNumber {
    public enum Error {
        case overflow
    }
}

extension DayNumber.Error: Swift.Equatable {}

extension DayNumber.Error: Swift.Error {}
