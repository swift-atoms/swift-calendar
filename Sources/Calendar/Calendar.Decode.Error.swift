extension Calendar.Decode {
    public enum Error: Swift.Error, Swift.Equatable {
        case unsupported(DayNumber)
    }
}
