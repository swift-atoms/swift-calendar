// Keep the representation independent of Date: see the linter's
// [API-ERR-009] phantom-generic-error rule. Public signatures use the domain alias.
/// The date lies outside the supported encoding domain. The caller retains the date.
public enum __CalendarEncodeError {
    case unsupported
}

extension __CalendarEncodeError: Swift.Equatable {}

extension Calendar.Encode {
    public typealias Error = __CalendarEncodeError
}

extension Calendar.Encode.Error: Swift.Error {}
