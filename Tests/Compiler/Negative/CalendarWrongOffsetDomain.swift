// EXPECT-ERROR: no exact matches|cannot convert|conflicting arguments
import Affine
import Calendar
import Difference
import Time

func secondsCannotAdvanceCalendarDates() throws {
    let calendar = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
    let seconds = Affine.Position<Time.Second>.Offset(1)
    let _ = try calendar.adding(days: seconds, to: DayNumber(rawValue: 0))
}
