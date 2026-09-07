// Keep the representation independent of Date: see the linter's
// [API-ERR-009] phantom-generic-error rule. Public signatures use the domain alias.
/// Failures composed by calendar arithmetic and conversion.
public enum __CalendarError {
    case encode(__CalendarEncodeError)
    case decode(__CalendarDecodeError)
    case arithmetic(DayNumber.Error)
}

extension Calendar.Error: Swift.Equatable {}

extension Calendar {
    public typealias Error = __CalendarError
}

extension Calendar.Error: Swift.Error {}
