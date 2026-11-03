# swift-calendar

Use the `Calendar` module when you have your own date representation and need to add days to it, count the days between two dates, or convert a date into another calendar's representation: describe the representation once as a `Calendar<Date>`, a pair of encode and decode directions between `Date` and the shared day coordinate `DayNumber`, and every calendar built that way can be converted to every other. `DateTime<Date>` pairs such a date with a time of day. For an instant on the Unix-epoch timeline, a duration or a UTC offset, use swift-time instead; for a monotonic clock, use swift-clock.

## Laws

- A `Calendar<Date>` must be a partial isomorphism: for every `Date` it encodes, decoding the resulting `DayNumber` yields that same date, and for every `DayNumber` it decodes, encoding the result yields that same day number. Nothing checks this; arithmetic and conversion silently give wrong answers for a calendar that breaks it.
- One day is one step of `DayNumber.rawValue`. All calendar arithmetic happens on `DayNumber`, never on `Date`: `adding(days:to:)` encodes, advances, then decodes, and fails with `Calendar<Date>.Error.encode`, `Calendar<Date>.Error.arithmetic` or `Calendar<Date>.Error.decode` according to which of those three steps failed, in that order.
- `distance(from:to:)` only encodes both dates. It never decodes and never overflows: the displacement between any two `DayNumber` values, including `Int64.min` to `Int64.max`, is representable, and adding it back to the start returns the end.
- `DayNumber.advanced(by:)` fails with `DayNumber.Error.overflow` exactly when the result falls outside `Int64`.
- `convert(_:to:)` encodes with the source calendar and decodes with the target. A target that cannot decode the day is reported in the source's error domain, as `Calendar<Date>.Error.decode` carrying the unsupported `DayNumber`.
- `DayNumber` orders by its raw value.
