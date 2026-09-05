extension Calendar {
    public func adding(days: Int64, to date: Date) throws(Calendar<Date>.Error) -> Date {
        let day: DayNumber
        do throws(Calendar<Date>.Encode.Error) {
            day = try dayNumber(of: date)
        } catch {
            throw .encode(error)
        }
        let result: DayNumber
        do throws(DayNumber.Error) {
            result = try day.adding(days)
        } catch {
            throw .arithmetic(error)
        }
        do throws(Calendar<Date>.Decode.Error) {
            return try self.date(on: result)
        } catch {
            throw .decode(error)
        }
    }

    public func distance(from start: Date, to end: Date) throws(Calendar<Date>.Error) -> Int64 {
        let first: DayNumber
        let last: DayNumber
        do throws(Calendar<Date>.Encode.Error) {
            first = try dayNumber(of: start)
            last = try dayNumber(of: end)
        } catch {
            throw .encode(error)
        }
        do throws(DayNumber.Error) {
            return try first.distance(to: last)
        } catch {
            throw .arithmetic(error)
        }
    }
}
