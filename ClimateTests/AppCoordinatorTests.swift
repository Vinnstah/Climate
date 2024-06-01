import XCTest
import ComposableArchitecture
import CoreLocation

@testable import Climate

final class AppCoordinatorTests: XCTestCase {
    let testStore = TestStore(initialState: AppCoordinator.State()) {
        AppCoordinator()
    }
    
    func testSearchTapped() async {
        testStore.exhaustivity = .off
        await testStore.send(.view(.searchTapped)) { state in
            state.destination = .search(.init())
        }
    }
    
    func testMainTapped() async {
        testStore.exhaustivity = .off
        await testStore.send(.view(.mainTapped)) { state in
            state.destination = .main(.init(weather: Shared(.mock)))
        }
    }
}
