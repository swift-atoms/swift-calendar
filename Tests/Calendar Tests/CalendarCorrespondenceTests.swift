import Calendar
import Optic
import Testing

@Suite
private struct `Calendar directions compose through fixed coordinates` {
    @Test
    func `first class directions retain their leaf failure domains`() throws {
        let encode = Calendar<String>.Encode { value throws(Calendar<String>.Encode.Error) in
            guard value == "origin" else { throw .unsupported }
            return DayNumber(rawValue: 0)
        }
        let decode = Calendar<String>.Decode { day throws(Calendar<String>.Decode.Error) in
            guard day.rawValue == 0 else { throw .unsupported(day) }
            return "origin"
        }
        let calendar = Calendar(encode: encode, decode: decode)
        #expect(try encode("origin") == DayNumber(rawValue: 0))
        #expect(try decode(DayNumber(rawValue: 0)) == "origin")
        #expect(try calendar.encode("origin") == calendar.dayNumber(of: "origin"))
        #expect(try calendar.decode(DayNumber(rawValue: 0)) == calendar.date(on: DayNumber(rawValue: 0)))
        #expect(throws: Calendar<String>.Encode.Error.unsupported) { try calendar.encode("missing") }
        #expect(throws: Calendar<String>.Decode.Error.unsupported(DayNumber(rawValue: 1))) {
            try calendar.decode(DayNumber(rawValue: 1))
        }
    }

    @Test(arguments: [Int64.min, -1, 0, 1, Int64.max])
    func `calendar correspondences compose through shared fixed coordinates`(rawValue: Int64) throws {
        let source = Calendar<Int64>(dayNumber: { DayNumber(rawValue: $0) }, date: { $0.rawValue })
        let target = Calendar<DayNumber>(dayNumber: { $0 }, date: { $0 })
        let conversion = source.correspondence.appending(target.correspondence.reversed)
        let result = try conversion.forward(rawValue)
        #expect(result.rawValue == rawValue)
        #expect(try conversion.backward(result) == rawValue)
        #expect(try source.convert(rawValue, to: target) == result)
    }
}
