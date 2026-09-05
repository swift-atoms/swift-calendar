internal import Difference

extension Calendar {
    public func adding(days: Int64, to date: Date) throws(Calendar<Date>.Error) -> Date {
        try adding(days: DayNumber.Offset(Int(days)), to: date)
    }

    /// Translates by a typed displacement, including distances wider than Int64.
    public func adding(days: DayNumber.Offset, to date: Date) throws(Calendar<Date>.Error) -> Date {
        let day: DayNumber
        do throws(Calendar<Date>.Encode.Error) {
            day = try dayNumber(of: date)
        } catch {
            throw .encode(error)
        }
        let result: DayNumber
        do throws(DayNumber.Error) {
            result = try day.advanced(by: days)
        } catch {
            throw .arithmetic(error)
        }
        do throws(Calendar<Date>.Decode.Error) {
            return try self.date(on: result)
        } catch {
            throw .decode(error)
        }
    }

    public func distance(from start: Date, to end: Date) throws(Calendar<Date>.Error) -> DayNumber.Offset {
        let first: DayNumber
        let last: DayNumber
        do throws(Calendar<Date>.Encode.Error) {
            first = try dayNumber(of: start)
            last = try dayNumber(of: end)
        } catch {
            throw .encode(error)
        }
        return first.distance(to: last)
    }
}
