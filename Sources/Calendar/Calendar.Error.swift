extension Calendar {
    public enum Error: Swift.Error, Swift.Equatable {
        case encode(Encode.Error)
        case decode(Decode.Error)
        case arithmetic(DayNumber.Error)
    }
}
