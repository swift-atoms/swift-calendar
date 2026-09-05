import Calendar
import Difference

func calendarArithmeticPreservesTheDayDomain() throws {
    let calendar = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
    let first = DayNumber(rawValue: .min)
    let last = DayNumber(rawValue: .max)
    let days: DayNumber.Offset = try calendar.distance(from: first, to: last)
    let _: DayNumber = try calendar.adding(days: days, to: first)
    let _: DayNumber = try first.advanced(by: days)
}

func calendarDirectionsAreFirstClass() throws {
    let encode = Calendar<Int64>.Encode { DayNumber(rawValue: $0) }
    let decode = Calendar<Int64>.Decode { $0.rawValue }
    let calendar = Calendar(encode: encode, decode: decode)
    let day: DayNumber = try calendar.encode(42)
    let _: Int64 = try calendar.decode(day)
}
