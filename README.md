# Climate

A dual screen Weather application built with TCA.
Fetches the users current location and displays the weather. Thereäs also a option to search for a custom location to display the weather there.

# How to run it?

Create a `.envrc` file in the root folder and add the key `API_KEY` with the corresponding value from the `https://openweathermap.org/` API.

# Architectural decisions
I've chosen TCA as the main architecture due to the ease of testing as well as previous experience with it.
Dependencyinjection is another huge plus since it's easily testable and handled by the `swift-dependencies` library.
I've chosen to share state between Parent, Child and Coordinators in order to simplify the creation of business-logic at the expense of some testability.
