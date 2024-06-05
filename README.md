# Climate

A dual screen Weather application built with The Composable Architecture (TCA).
Fetches the users current location and displays the weather. There's also a option to search for a custom location to display the weather there.

# How to run it?

Add an environment variable name `API_KEY` with your API key from `https://openweathermap.org/` API.
In order to get it working for `CI`, e.g. `GitHub Actions`, the environment variable needs to be added to GitHub or injected directly in the workflow (not recommended)

# Architectural decisions
I've chosen TCA as the main architecture due to the ease of testing as well as previous experience with it.
Dependency-injection is another huge plus since it's easily testable and handled by the `swift-dependencies` library.
I've chosen to share state between Parent, Child and Coordinators in order to simplify the creation of business-logic at the expense of some testability.

A potential drawback of using TCA is the readability of the code if you're not familiar with the architecture of the library. 

