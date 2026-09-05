extension Calendar {
    public func convert<OtherDate>(
        _ date: Date, to calendar: Calendar<OtherDate>
    ) throws(Calendar<Date>.Error) -> OtherDate {
        let day: DayNumber
        do throws(Calendar<Date>.Encode.Error) {
            day = try dayNumber(of: date)
        } catch {
            throw .encode(error)
        }
        do throws(Calendar<OtherDate>.Decode.Error) {
            return try calendar.date(on: day)
        } catch {
            throw .decode(error)
        }
    }
}
