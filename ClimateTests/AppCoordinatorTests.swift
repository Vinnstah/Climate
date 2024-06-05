import XCTest
import ComposableArchitecture
import CoreLocation

@testable import Climate

final class AppCoordinatorTests: XCTestCase {
    let testStore = TestStore(
        initialState: AppCoordinator.State(
            location: Shared(
                .empty
            ),
            weather: Shared(.preview)
        )
    ) {
        AppCoordinator()
    }
    
    func test__GIVEN__home__WHEN__searchButton_is_tapped__THEN__search_screen_is_presented() async {
        testStore.exhaustivity = .off
        await testStore.send(.view(.searchTapped)) { state in
            state.destination = .search(.init(location: state.$location))
        }
    }
    
    func test__GIVEN__search__WHEN__homeButton_is_tapped__THEN__home_screen_is_presented() async {
        testStore.exhaustivity = .off
        await testStore.send(.view(.mainTapped)) { state in
            state.destination = .main(.init(weather: state.weather, location: state.location))
        }
    }
    
    func test__GIVEN__startup__WHEN__onAppear_is_triggered__THEN__home_screen_is_presented() async {
        testStore.exhaustivity = .off
        await testStore.send(.view(.onAppear)) { state in
            state.destination = .main(.init(weather: state.weather, location: state.location))
        }
    }
}
