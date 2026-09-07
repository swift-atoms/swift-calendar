import Testing
import Calendar
import Time
import Difference
import Tagged

private final class LocalDate {
    let value: Int64
    init(_ value: Int64) { self.value = value }
}

private final class LocalContext { var origin: Int64 = 10 }

private func makeCalendar() -> sending Calendar<LocalDate> {
    let context = LocalContext()
    return Calendar(
        dayNumber: { date throws(Calendar<LocalDate>.Encode.Error) in
            do throws(DayNumber.Error) {
                return try DayNumber(rawValue: date.value).adding(context.origin)
            } catch {
                throw .unsupported
            }
        },
        date: { day throws(Calendar<LocalDate>.Decode.Error) in
            do throws(Difference.Error) {
                return LocalDate(Int64(try DayNumber(rawValue: context.origin).distance(to: day).underlying.intValue()))
            } catch {
                throw .unsupported(day)
            }
        }
    )
}

private actor CalendarReceiver {
    private var calendar: Calendar<LocalDate>?
    func store(_ calendar: sending Calendar<LocalDate>) { self.calendar = calendar }
    func dayNumber() throws -> Int64? { try calendar?.dayNumber(of: LocalDate(2)).rawValue }
}

private actor DateTimeReceiver {
    private var dateTime: DateTime<LocalDate>?
    func store(_ dateTime: sending DateTime<LocalDate>) { self.dateTime = dateTime }
    func value() -> Int64? { dateTime?.date.value }
}

private func makeDateTime() -> sending DateTime<LocalDate> { DateTime(date: LocalDate(42)) }
private func requireSendable<T: Sendable>(_ value: T) {}
private struct EqualityOnly: Equatable { let value: Int }

@Suite struct `Calendars preserve isolation and ownership` {
    @Test func `local construction does not transfer aliases`() throws {
        let date = LocalDate(1)
        let calendar = makeCalendar()
        let value = DateTime(date: date)
        #expect(value.date === date)
        #expect(try calendar.dayNumber(of: date).rawValue == 11)
        #expect(try calendar.date(on: DayNumber(rawValue: 11)).value == date.value)
    }

    @Test func `equality does not require hashability`() {
        #expect(DateTime(date: EqualityOnly(value: 1)) == DateTime(date: EqualityOnly(value: 1)))
    }

    @Test func `conditional hashability and sendability remain available`() {
        let value = DateTime(date: DayNumber(rawValue: 42))
        requireSendable(value)
        #expect(Set([value, value]).count == 1)
    }

    @Test func `ordinary closures can retain locally aliased state`() throws {
        let context = LocalContext()
        let calendar = Calendar<LocalDate>(
            dayNumber: { date throws(Calendar<LocalDate>.Encode.Error) in
                do throws(DayNumber.Error) {
                    return try DayNumber(rawValue: date.value).adding(context.origin)
                } catch {
                    throw .unsupported
                }
            },
            date: { day throws(Calendar<LocalDate>.Decode.Error) in
                do throws(Difference.Error) {
                    return LocalDate(Int64(try DayNumber(rawValue: context.origin).distance(to: day).underlying.intValue()))
                } catch {
                    throw .unsupported(day)
                }
            }
        )
        #expect(context.origin == 10)
        #expect(try calendar.dayNumber(of: LocalDate(1)).rawValue == 11)
    }

    @Test func `captured calendar state can be transferred as one region`() async throws {
        let receiver = CalendarReceiver()
        let calendar = makeCalendar()
        await receiver.store(calendar)
        #expect(try await receiver.dayNumber() == 12)
    }

    @Test func `non sendable date time can be transferred as one region`() async {
        let receiver = DateTimeReceiver()
        let value = makeDateTime()
        await receiver.store(value)
        #expect(await receiver.value() == 42)
    }
}
