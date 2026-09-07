internal import Either
internal import Optic

extension Calendar {
    public func convert<OtherDate>(
        _ date: Date, to calendar: Calendar<OtherDate>
    ) throws(Calendar<Date>.Error) -> OtherDate {
        let conversion = correspondence.appending(calendar.correspondence.reversed)
        do throws(Either<Calendar<Date>.Encode.Error, Calendar<OtherDate>.Decode.Error>) {
            return try conversion.forward(date)
        } catch {
            switch error {
            case .left(let error): throw .encode(error)
            case .right(.unsupported(let day)): throw .decode(.unsupported(day))
            }
        }
    }
}
