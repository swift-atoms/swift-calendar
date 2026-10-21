import Calendar
import Testing

@Suite struct `Calendar conversion preserves nested error payloads` {
    @Test(arguments: [Int64.min, -1, 0, 1, Int64.max])
    func `target decode failures retain the unsupported coordinate at the source boundary`(
        rawValue: Int64
    ) {
        let source = Calendar<DayNumber>(
            dayNumber: { day throws(Calendar<DayNumber>.Encode.Error) in day },
            date: { day throws(Calendar<DayNumber>.Decode.Error) in day }
        )
        let target = Calendar<String>(
            dayNumber: { _ throws(Calendar<String>.Encode.Error) in throw .unsupported },
            date: { day throws(Calendar<String>.Decode.Error) in throw .unsupported(day) }
        )
        let day = DayNumber(rawValue: rawValue)
        #expect(throws: Calendar<String>.Decode.Error.unsupported(day)) { try target.date(on: day) }
        #expect(throws: Calendar<DayNumber>.Error.decode(.unsupported(day))) {
            try source.convert(day, to: target)
        }
    }

    @Test func `source encoding failures keep their owning error domain`() {
        let source = Calendar<String>(
            dayNumber: { _ throws(Calendar<String>.Encode.Error) in throw .unsupported },
            date: { day throws(Calendar<String>.Decode.Error) in throw .unsupported(day) }
        )
        let target = Calendar<DayNumber>(
            dayNumber: { day throws(Calendar<DayNumber>.Encode.Error) in day },
            date: { day throws(Calendar<DayNumber>.Decode.Error) in day }
        )
        #expect(throws: Calendar<String>.Error.encode(.unsupported)) {
            try source.convert("unsupported", to: target)
        }
    }
}
