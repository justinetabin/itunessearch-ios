# iTunesSearch iOS
* A simple master-detail app that communicates with iTunes Search public APIs. It displays movies in a list manner and shows a movie for it's details with trailer preview to autoplay.

# iTunesStore API
* Check it out the <a href="https://affiliate.itunes.apple.com/resources/documentation/itunes-store-web-service-search-api/#searching">**Documentation**</a>.

# Architecture Overview
This project's architecture highlights separation of concerns.

### Service Layer
- Encapsulates the interaction between 3rd party service or API.

### Worker Layer
- Encapsulates the complex business or presentation logic and make them reusable.

### Scene Layer
- The UI that can be easily added or swapped in and out without changing any business logic.
  - Used MVVM but with a much stricter ViewModels since it will only consists of purely view logics / view transformations
  - MVVM is scaleable, easier to read and works well with functional programming paradigms

# Dependencies
* Caching via CoreData
  - Used a wrapper to wrap a basic iTunesApi service so we are flexible and testable
  - For simplicity and under the hood ready-to-use background threading
* RxSwift / RxRelay / RxCocoa
  - Used mainly in View <-> ViewModels input/output bindings
  - Makes the View, ViewModels less clattered, more readable and functional
  - Used only under View, ViewModels so the inner layers won't have any dependencies in the outer layers
* SnapKit
  - Easier debugging and easier to git merge
* Kingfisher
  - Production tested and background caching of remote images

# Includes
* Dark Mode
* Portrait / Landscape modes
* Autoplays trailer preview
* Offline Support

# Room for improvements
* Unit tests for ViewModels, ViewControllers
* Some view logic in viewmodels would also be good to be shared and moved on a worker
* Pagination

# Requirements
* Xcode Version 11.3+ Swift 5.0+
* Compatible with iPads / iPhones
