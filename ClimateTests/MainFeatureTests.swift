import XCTest
import ComposableArchitecture
import CoreLocation

@testable import Climate

final class MainFeatureTests: XCTestCase {
    let testClock = TestClock()
    
    let testStore: TestStoreOf<Main> = TestStore(
        initialState: Main.State(weather: .empty, location: .init(location: .init())) ) {
            Main()
        }
withDependencies: {
    $0.locationClient.getCurrentLocation = {
        .success(
            .init(
                latitude: .init(
                    floatLiteral: 59.334591
                ),
                longitude: .init(floatLiteral: 18.063240)
            )
        )
    }
    $0.locationClient.requestAuthorization = { .success(.init()) }
    $0.weatherClient.currentWeatherAt = { _ in .preview }
    $0.weatherClient.fiveDayForecast = { _ in .preview }
}
    
    func test__GIVEN__navigate_to_main_on_startup__WHEN__onAppear_triggers__THEN__request_authorization() async {
        testStore.exhaustivity = .off
        
        await testStore.send(.view(.onAppear))
        await testStore.receive(.location(.requestAuthorization(.success(.init()))))
    }
    
    func test__GIVEN__onAppear__WHEN__authorization_successful__THEN__fetch_current_weather() async {
        
        await testStore.send(
            .weather(
                .getWeatherForCurrentLocation(
                    try! await testStore.dependencies.weatherClient.currentWeatherAt(
                        .init(location: testStore.state.location, temperatureUnits: .metric)
                    )
                )
            )
        ) {
            $0.weather = .preview
        }
    }
    
    func test__GIVEN__onAppear__WHEN__getCurrentWeather_successful__THEN__fetch_forecast() async {
        
        await testStore.send(
            .weather(
                .getForecastForCurrentLocation(
                    try! await testStore.dependencies.weatherClient.fiveDayForecast(
                        .init(latitude: 59.334591, longitude: 18.063240, units: .metric)
                    )
                )
            )
        ) {
            $0.forecast = .preview
        }
    }
}
