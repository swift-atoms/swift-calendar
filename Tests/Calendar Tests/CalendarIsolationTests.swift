import Testing
import Calendar
import Time

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
            do throws(DayNumber.Error) {
                return LocalDate(try DayNumber(rawValue: context.origin).distance(to: day))
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

@Suite struct CalendarIsolationTests {
    @Test func localConstructionDoesNotTransferAliases() throws {
        let date = LocalDate(1)
        let calendar = makeCalendar()
        let value = DateTime(date: date)
        #expect(value.date === date)
        #expect(try calendar.dayNumber(of: date).rawValue == 11)
        #expect(try calendar.date(on: DayNumber(rawValue: 11)).value == date.value)
    }

    @Test func equalityDoesNotRequireHashability() {
        #expect(DateTime(date: EqualityOnly(value: 1)) == DateTime(date: EqualityOnly(value: 1)))
    }

    @Test func conditionalHashabilityAndSendabilityRemainAvailable() {
        let value = DateTime(date: DayNumber(rawValue: 42))
        requireSendable(value)
        #expect(Set([value, value]).count == 1)
    }

    @Test func ordinaryClosuresCanRetainLocallyAliasedState() throws {
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
                do throws(DayNumber.Error) {
                    return LocalDate(try DayNumber(rawValue: context.origin).distance(to: day))
                } catch {
                    throw .unsupported(day)
                }
            }
        )
        #expect(context.origin == 10)
        #expect(try calendar.dayNumber(of: LocalDate(1)).rawValue == 11)
    }

    @Test func capturedCalendarStateCanBeTransferredAsOneRegion() async throws {
        let receiver = CalendarReceiver()
        let calendar = makeCalendar()
        await receiver.store(calendar)
        #expect(try await receiver.dayNumber() == 12)
    }

    @Test func nonSendableDateTimeCanBeTransferredAsOneRegion() async {
        let receiver = DateTimeReceiver()
        let value = makeDateTime()
        await receiver.store(value)
        #expect(await receiver.value() == 42)
    }
}
