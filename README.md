# Weather app

Build with xcode 7.1, ios sdk 9.1. Tested on iphone and ipad simulators.
In order to build open WiproWeather.xcodeproj and run simulator

# Tradeoffs
Some of elements i would change if i would continue working on the project:
- communication, in basic implementation i'm using callback to synchronise between view and model, for growing application i would start using delegates or events 
- configuration, current project has hardcoded url, appid etc, this should be part of external config
- implement proper logic to Representative Weather Point and handle multiple weatherConditions
- implement detailed view, for very basic application i would continue using sotryboard, for something complex i would move view flow controll to code
- error handling currently only prints message to console, it should track errors on backend and communicate problem to user
- expose more configuration for user (select location, units)
- add caching/persistance for data and images, move download code from view
- add tests
