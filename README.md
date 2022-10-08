# Secure To-Do List App
This application is created to use some frameworks and patterns. 3rd party libraries are not used. The following items were used while developing this application. 

- Programmatically Auto Layout
- MVVM Design Pattern
- Protocol oriented programing
- Diffable data source
- Core Data
- Combine Framework
- iOS Keychain
- Unit/UI Tests

## Detail
While developing the project, Programmatically Auto Layout and MVVM Design Pattern were used. Protocol oriented structure has been established. While showing to-do items, diffable data source is used. To-do items are stored in Core Data using the combine framework. The password used by the user to login to the application is stored in the keychain. Again, the communication between the keychain and the interface is provided using the combine framework. Unit tests for "CoreDataHelper" and "KeyChainHelper" have been added to the project. Also, UITests have been added.

## Demo Mode 
There is "isDemoMode" variable in "LoginViewController". If you set as true, application login password set as "leventozgur123" automatically.


## Screenshots
<img src="https://github.com/leventozgur/Secure-To-Do-App/blob/main/Screenshots/ss_01.png?raw=true" alt="drawing" width="200" style="border: 1px solid;">
<img src="https://github.com/leventozgur/Secure-To-Do-App/blob/main/Screenshots/ss_02.png?raw=true" alt="drawing" width="200" style="border: 1px solid;">
<img src="https://github.com/leventozgur/Secure-To-Do-App/blob/main/Screenshots/ss_03.png?raw=true" alt="drawing" width="200" style="border: 1px solid;">
<img src="https://github.com/leventozgur/Secure-To-Do-App/blob/main/Screenshots/ss_04.png?raw=true" alt="drawing" width="200" style="border: 1px solid;">

## Unit & UI Tests
<img src="https://github.com/leventozgur/Secure-To-Do-App/blob/main/Screenshots/tests.png?raw=true" alt="drawing" width="400" style="border: 1px solid;">