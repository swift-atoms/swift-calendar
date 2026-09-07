// Keep the representation independent of Date: see the linter's
// [API-ERR-009] phantom-generic-error rule. Public signatures use the domain alias.
/// Failures composed by calendar arithmetic and conversion.
public enum __CalendarError {
    case encode(Calendar<Never>.Encode.Error)
    case decode(Calendar<Never>.Decode.Error)
    case arithmetic(DayNumber.Error)
}

extension __CalendarError: Swift.Equatable {}

extension Calendar {
    public typealias Error = __CalendarError
}
