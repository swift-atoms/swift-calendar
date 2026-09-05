import Testing
import Calendar
import Time
import Difference
import Cardinal
import Magnitude
import Polarity
import Tagged

private struct WeekDate: Equatable {
    let week: Int64
    let weekday: Int
}

/// A date representation with weeks and weekdays, and no year or month.
private func weekCalendar() -> sending Calendar<WeekDate> {
    Calendar(
        dayNumber: { date throws(Calendar<WeekDate>.Encode.Error) in
            guard (1...7).contains(date.weekday) else { throw .unsupported }
            let value = Int128(date.week) * 7 + Int128(date.weekday - 1)
            guard let rawValue = Int64(exactly: value) else { throw .unsupported }
            return DayNumber(rawValue: rawValue)
        },
        date: { day in
            let quotient = day.rawValue / 7
            let remainder = day.rawValue % 7
            return WeekDate(
                week: remainder < 0 ? quotient - 1 : quotient,
                weekday: Int(remainder < 0 ? remainder + 7 : remainder) + 1
            )
        }
    )
}

@Suite struct CalendarAlgebraTests {
    @Test(arguments: [Int64.min, -8, -7, -1, 0, 1, 6, 7, 8, Int64.max])
    func inverseLawsForADateWithoutMonths(rawValue: Int64) throws {
        let calendar = weekCalendar()
        let day = DayNumber(rawValue: rawValue)
        let date = try calendar.date(on: day)
        #expect(try calendar.dayNumber(of: date) == day)
        #expect(try calendar.date(on: calendar.dayNumber(of: date)) == date)
    }

    @Test func advancementAndDistanceAreDerivedFromCoordinates() throws {
        let calendar = weekCalendar()
        let start = WeekDate(week: -1, weekday: 7)
        let end = try calendar.adding(days: 8, to: start)
        #expect(end == WeekDate(week: 1, weekday: 1))
        #expect(try calendar.adding(days: 0, to: start) == start)
        #expect(try calendar.adding(days: 5, to: calendar.adding(days: 3, to: start)) == end)
        #expect(try calendar.distance(from: start, to: end).underlying == 8)
        #expect(try calendar.distance(from: end, to: start).underlying == -8)
        #expect(try calendar.adding(days: calendar.distance(from: start, to: end), to: start) == end)
        #expect(try calendar.adding(days: -8, to: end) == start)
    }

    @Test func conversionBetweenRepresentations() throws {
        let source = weekCalendar()
        let target = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
        let date = WeekDate(week: 42, weekday: 3)
        let converted = try source.convert(date, to: target)
        #expect(converted.rawValue == 296)
        #expect(try target.convert(converted, to: source) == date)
    }

    @Test func partialDomainsReportTypedErrors() {
        let calendar = Calendar<String>(
            dayNumber: { value throws(Calendar<String>.Encode.Error) in
                guard value == "origin" else { throw .unsupported }
                return DayNumber(rawValue: 0)
            },
            date: { day throws(Calendar<String>.Decode.Error) in
                guard day.rawValue == 0 else { throw .unsupported(day) }
                return "origin"
            }
        )
        #expect(throws: Calendar<String>.Encode.Error.unsupported) { try calendar.dayNumber(of: "missing") }
        #expect(throws: Calendar<String>.Error.decode(.unsupported(DayNumber(rawValue: 1)))) {
            try calendar.adding(days: 1, to: "origin")
        }
    }

    @Test func composedOperationsPreserveLeafErrors() {
        let origin = Calendar<String>(
            dayNumber: { value throws(Calendar<String>.Encode.Error) in
                guard value == "origin" else { throw .unsupported }
                return DayNumber(rawValue: 0)
            },
            date: { day throws(Calendar<String>.Decode.Error) in
                guard day.rawValue == 0 else { throw .unsupported(day) }
                return "origin"
            }
        )
        let identity = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
        let missing = DayNumber(rawValue: 1)
        #expect(throws: Calendar<String>.Decode.Error.unsupported(missing)) {
            try origin.date(on: missing)
        }
        #expect(throws: Calendar<String>.Error.encode(.unsupported)) {
            try origin.adding(days: 0, to: "missing")
        }
        #expect(throws: Calendar<String>.Error.encode(.unsupported)) {
            try origin.distance(from: "origin", to: "missing")
        }
        #expect(throws: Calendar<String>.Error.encode(.unsupported)) {
            try origin.convert("missing", to: identity)
        }
        #expect(throws: Calendar<DayNumber>.Error.decode(.unsupported(missing))) {
            try identity.convert(missing, to: origin)
        }
        #expect(throws: Calendar<DayNumber>.Error.arithmetic(.overflow)) {
            try identity.adding(days: 1, to: DayNumber(rawValue: .max))
        }
    }

    @Test func errorDomainsDoNotDependOnDateRepresentation() {
        let encode: Calendar<String>.Encode.Error = Calendar<Int>.Encode.Error.unsupported
        let decode: Calendar<String>.Decode.Error = Calendar<Int>.Decode.Error.unsupported(.init(rawValue: 1))
        let composed: Calendar<String>.Error = Calendar<Int>.Error.decode(decode)
        #expect(encode == .unsupported)
        #expect(composed == .decode(.unsupported(.init(rawValue: 1))))
    }

    @Test func checkedCoordinateArithmetic() {
        #expect(throws: DayNumber.Error.overflow) { try DayNumber(rawValue: .max).adding(1) }
        #expect(throws: DayNumber.Error.overflow) { try DayNumber(rawValue: .min).adding(-1) }
        let distance = DayNumber(rawValue: .min).distance(to: DayNumber(rawValue: .max))
        #expect(distance.underlying.magnitude.value.rawValue == UInt.max)
        #expect(distance.underlying.polarity == .positive)
    }

    @Test func `full coordinate range has a representable displacement`() throws {
        let calendar = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
        let start = DayNumber(rawValue: .min)
        let end = DayNumber(rawValue: .max)
        let forward = try calendar.distance(from: start, to: end)
        let backward = try calendar.distance(from: end, to: start)
        #expect(forward.underlying.magnitude.value.rawValue == UInt.max)
        #expect(backward.underlying == -forward.underlying)
        #expect(try calendar.adding(days: forward, to: start) == end)
        #expect(try calendar.adding(days: backward, to: end) == start)
        #expect(throws: Calendar<DayNumber>.Error.arithmetic(.overflow)) {
            try calendar.adding(days: forward, to: end)
        }
    }

    @Test func dateTimeComposesTheDateRepresentationWithTemporalAtoms() throws {
        let date = WeekDate(week: 42, weekday: 3)
        let value = DateTime(
            date: date, hour: try Time.Hour(12),
            millisecond: try .init(123), microsecond: try .init(456), nanosecond: try .init(789)
        )
        #expect(value.date == date)
        #expect(value.hour.value == 12)
        #expect(value.totalNanoseconds == 123_456_789)
        #expect(Time.Epoch(referenceDate: value).referenceDate == value)
    }
}
