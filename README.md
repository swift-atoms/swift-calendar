# swift-calendar

A calendar is a correspondence between its complete date representation and a common
fixed-day coordinate. The core imposes no year, month, weekday, leap-year or date-validation
structure on that representation.

```swift
import Calendar

let identity = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
let tomorrow = try identity.adding(days: 1, to: DayNumber(rawValue: 1))
```

`Calendar<Date>` stores an `Optic.Isomorphism.Partial` whose two directions are ordinary
conversion closures. The immutable `Calendar<Date>.Encode` and `.Decode` values are
independently callable; use `Calendar(encode:decode:)` to assemble them, or the closure
initializer above. Date-to-coordinate encoding
throws `Calendar<Date>.Encode.Error.unsupported`; coordinate-to-date decoding throws
`Calendar<Date>.Decode.Error.unsupported(DayNumber)`. Encoding errors do not retain the
date, so arbitrary date representations remain unconstrained by Sendable.

Checked coordinate arithmetic throws `DayNumber.Error.overflow`. Composed operations
throw `Calendar<Date>.Error`, preserving the leaf cause in `.encode`, `.decode` or
`.arithmetic`. The error representations are independent of Date; nested aliases retain
the domain spelling while avoiding the compiler's phantom-generic typed-error issue.
The supplied functions must be inverses on their supported domain:

```
date(dayNumber(d)) = d
dayNumber(date(n)) = n
```

`adding(days:to:)`, `distance(from:to:)` and `convert(_:to:)` are derived solely by
composing these functions with checked day-coordinate arithmetic. Calendar conversion
uses shared partial-isomorphism composition; directional failures retain their origin
before being mapped to the calendar's error cases. The public `correspondence` can also
be reversed or composed directly, preserving the inverse laws over the common supported
domain. An unrestricted `Optic.Adapter` makes no such law claim. A represented date's
semantic equality need not be provided as a Swift Equatable conformance.

`DayNumber.Offset` is a tagged `Difference`. Distance spans the entire signed coordinate
range, including the displacement from `Int64.min` to `Int64.max`. Advancement accepts
that typed displacement and reports overflow only when the resulting coordinate lies
outside the representable range. The Int64 `adding(days:to:)` overload remains a convenient
way to express smaller displacements.

`DayNumber` uses an Int64 Rata Die coordinate: day 1 denotes proleptic Gregorian
0001-01-01, and day 0 its predecessor. This origin is a shared convention, not a code
dependency on Gregorian. These coordinates are neither instants nor elapsed durations.
Every adapter must agree on the fixed-day convention. Location, observed calendar variants,
physical day boundaries and time-scale interpretation must be resolved separately.

The calendar argument Date is unconstrained. Callbacks can capture local, non-sendable
context. Factories may return `sending Calendar<Date>` for transfer; ordinary construction
and local calls do not force a transfer. Captured context must retain stable semantics.
No shared static non-sendable calendar singleton is required.

`DateTime<Date>` composes any date representation with Time.Hour, Minute, Second,
Millisecond, Microsecond and Nanosecond. Its Sendable, Equatable and Hashable conformances
are conditional on Date. It makes no assumptions about the date's fields. This composition
is why Calendar depends on Time; the calendar correspondence itself uses no Time API.

The old Rules and System types are removed. Gregorian now owns its Year, Month, Month.Day,
Week and validated Date structure. Tests cover a week/weekday representation without
months, partial domains, arithmetic laws, and region-based transfer with non-sendable dates
and captured calendar context.
