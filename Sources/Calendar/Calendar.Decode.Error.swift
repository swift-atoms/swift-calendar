// Keep the representation independent of Date: see the linter's
// [API-ERR-009] phantom-generic-error rule. Public signatures use the domain alias.
/// The coordinate lies outside the supported decoding domain.
public enum __CalendarDecodeError {
    case unsupported(DayNumber)
}

extension __CalendarDecodeError: Swift.Equatable {}

extension Calendar.Decode {
    public typealias Error = __CalendarDecodeError
}

extension Calendar.Decode.Error: Swift.Error {}
