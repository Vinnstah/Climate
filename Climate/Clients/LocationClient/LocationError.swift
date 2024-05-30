import Foundation

public enum LocationError: Error, Equatable {
    case locationTrackingRestricted
    case locationTrackingDenied
    case locationServiceDisabled
    case failedToGetLastKnownLocation
}
