import Foundation
import PaperstowCore
import XCTest

final class UniqueLocationsTests: XCTestCase {
    func testSameCoordinatesAreNotANewPlace() {
        XCTAssertFalse(UniqueLocations.isNewPlace(lastLat: 10, lastLon: 77, nextLat: 10, nextLon: 77))
    }

    func testOneDegreeLatitudeIsFarMoreThan150Meters() {
        XCTAssertTrue(UniqueLocations.isNewPlace(lastLat: 0, lastLon: 0, nextLat: 1, nextLon: 0))
    }

    func testAbout150MetersOfLatitudeCountsAsANewPlace() {
        let metersPerDegree = 6_371_000.0 * Double.pi / 180.0
        let delta = UniqueLocations.minSeparationMeters / metersPerDegree
        XCTAssertTrue(UniqueLocations.isNewPlace(lastLat: 0, lastLon: 0, nextLat: delta, nextLon: 0))
        XCTAssertFalse(UniqueLocations.isNewPlace(lastLat: 0, lastLon: 0, nextLat: delta * 0.4, nextLon: 0))
    }

    func testHaversineIsSymmetric() {
        let a = UniqueLocations.metersBetween(lat1: 37.7749, lon1: -122.4194, lat2: 37.8044, lon2: -122.2711)
        let b = UniqueLocations.metersBetween(lat1: 37.8044, lon1: -122.2711, lat2: 37.7749, lon2: -122.4194)
        XCTAssertEqual(a, b, accuracy: 0.01)
        XCTAssertGreaterThan(a, 10_000)
    }

    func testInWindowDropsPointsOlderThan24Hours() {
        let now: Int64 = 1_700_000_000_000
        let places = [
            SafetyPlace(latitude: 1, longitude: 2, timestamp: now - 1_000),
            SafetyPlace(latitude: 3, longitude: 4, timestamp: now - UniqueLocations.windowMs - 1),
        ]
        let kept = UniqueLocations.inWindow(places, nowMs: now)
        XCTAssertEqual(kept.count, 1)
        XCTAssertEqual(kept[0].latitude, 1)
    }

    func testShareAllFormatsLastKnownAndEarlierMapsLinks() {
        let noon: Int64 = 1_704_110_400_000
        let earlier = noon - 3 * 60 * 60 * 1000
        let text = UniqueLocations.shareAll(
            placesNewestFirst: [
                SafetyPlace(latitude: 10, longitude: 20, timestamp: noon),
                SafetyPlace(latitude: 11, longitude: 21, timestamp: earlier),
            ],
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(identifier: "UTC")!
        )
        XCTAssertTrue(text.contains("Last known (12:00 PM):"))
        XCTAssertTrue(text.contains("https://maps.google.com/?q=10.0,20.0"))
        XCTAssertTrue(text.contains("Earlier:"))
        XCTAssertTrue(text.contains("https://maps.google.com/?q=11.0,21.0"))
    }

    func testShareAllEmptyListIsAClearMessage() {
        XCTAssertTrue(UniqueLocations.shareAll(placesNewestFirst: []).contains("no unique places"))
    }

    func testShareLastKnownIsAShortMapsLink() {
        let noon: Int64 = 1_704_110_400_000
        let text = UniqueLocations.shareLastKnown(
            SafetyPlace(latitude: 37.5, longitude: -122.1, timestamp: noon),
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(identifier: "UTC")!
        )
        XCTAssertTrue(text.hasPrefix("Paperstow — last known place"))
        XCTAssertTrue(text.contains("https://maps.google.com/?q=37.5,-122.1"))
    }

    func testShareIncludesBatteryWhenRecorded() {
        let noon: Int64 = 1_704_110_400_000
        let text = UniqueLocations.shareLastKnown(
            SafetyPlace(latitude: 37.5, longitude: -122.1, timestamp: noon, batteryPercent: 64),
            locale: Locale(identifier: "en_US"),
            timeZone: TimeZone(identifier: "UTC")!
        )
        XCTAssertTrue(text.contains("Battery 64%"))
        XCTAssertEqual(UniqueLocations.batteryLabel(64), "Battery 64%")
        XCTAssertNil(UniqueLocations.batteryLabel(-1))
    }
}
