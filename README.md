# iTunesSearch iOS
* A simple master-detail app that communicates with iTunes Search public APIs. It displays movies in a list manner and shows a movie for it's details with trailer preview to autoplay.

# iTunesStore API
* Check it out at <a href="https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/#searching">**Documentation**</a>.

# Architecture Overview
This project's architecture highlights separation of concerns.

### Service Layer
- Encapsulates the interaction between 3rd party service or API.

### Worker Layer
- Encapsulates the complex business or presentation logic and make them reusable.

### Scene Layer
- The UI that can be easily added or swapped in and out without changing any business logic.

# Dependencies
* Caching via CoreData
  - I used a wrapper to wrap a basic iTunesApi service so we are flexible and testable
  - I chose to use this for simplicity and under the hood ready-to-use background threading
* RxSwift / RxRelay / RxCocoa
  - I chose to use this mainly in View <-> ViewModels input/output bindings
  - This makes the View, ViewModels less clattered, more readable and functional
  - I chose to use this only under View, ViewModels so the inner layers won't have any dependencies in the outer layers
* SnapKit
  - I chose to use this mainly for easier debugging and easier to git merge

# Room for improvements
* Unit tests for ViewModels, ViewControllers
* Some view logic in viewmodels would also be good to be shared and moved on a worker

# Requirements
* Xcode Version 11.3+ Swift 5.0+
