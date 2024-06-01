import XCTest
import ComposableArchitecture

@testable import Climate

final class AppCoordinatorTests: XCTestCase {
    let testStore = TestStore(initialState: AppCoordinator.State()) {
        AppCoordinator()
    } withDependencies: {
        $0[HTTPClient.self] = HTTPClient.testValue
        $0[ApiClient.self] = ApiClient.testValue
        $0[LocationClient.self] = LocationClient.testValue
    }
    

    func testSearchTapped() async {
        testStore.exhaustivity = .off
        await testStore.send(.view(.searchTapped)) { state in
            state.destination = .search(.init())
        }
    }
}
