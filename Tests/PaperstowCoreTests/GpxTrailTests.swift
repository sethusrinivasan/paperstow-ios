import PaperstowCore
import XCTest

final class GpxTrailTests: XCTestCase {
    func testRoundTripKeepsCoordinatesTimeAndBattery() {
        let places = [
            SafetyPlace(latitude: 41.5, longitude: -72.5, timestamp: 1_717_200_000_000, batteryPercent: 84),
            SafetyPlace(latitude: 41.501, longitude: -72.498, timestamp: 1_717_200_600_000, batteryPercent: 81),
        ]
        let parsed = GpxTrail.parse(GpxTrail.toGpx(places))
        XCTAssertEqual(parsed.count, 2)
        XCTAssertEqual(parsed[0].latitude, 41.5, accuracy: 0.00001)
        XCTAssertEqual(parsed[0].longitude, -72.5, accuracy: 0.00001)
        XCTAssertEqual(parsed[0].batteryPercent, 84)
        XCTAssertEqual(parsed[1].batteryPercent, 81)
        XCTAssertEqual(parsed[0].timestamp, places[0].timestamp)
    }

    func testLooksLikeGpxDetectsHeader() {
        XCTAssertTrue(GpxTrail.looksLikeGpx(Array(GpxTrail.toGpx([]).utf8)))
    }
}
