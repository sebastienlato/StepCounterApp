import CoreMotion
import Foundation

protocol PedometerServiceProtocol {
    var isStepCountingAvailable: Bool { get }
    func queryData(from start: Date, to end: Date, handler: @escaping (CMPedometerData?, Error?) -> Void)
    func startUpdates(from start: Date, handler: @escaping (CMPedometerData?, Error?) -> Void)
    func stopUpdates()
}

final class PedometerService: PedometerServiceProtocol {
    private let pedometer = CMPedometer()

    var isStepCountingAvailable: Bool {
        CMPedometer.isStepCountingAvailable()
    }

    func queryData(from start: Date, to end: Date, handler: @escaping (CMPedometerData?, Error?) -> Void) {
        pedometer.queryPedometerData(from: start, to: end, withHandler: handler)
    }

    func startUpdates(from startOfDay: Date, handler: @escaping (CMPedometerData?, Error?) -> Void) {
        pedometer.startUpdates(from: startOfDay, withHandler: handler)
    }

    func stopUpdates() {
        pedometer.stopUpdates()
    }
}
