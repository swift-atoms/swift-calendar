// EXPECT-ERROR: cannot convert|conflicting arguments
import Affine
import Calendar
import Difference
import Time

func secondsCannotAdvanceFixedDayCoordinates() throws {
    let day = DayNumber(rawValue: 0)
    let seconds = Affine.Position<Time.Second>.Offset(1)
    let _ = try day.advanced(by: seconds)
}
