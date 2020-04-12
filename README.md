# Eurovision2020
Eurovision 2020 voting app

<img src="screen.png" width="300px"/>

## Firebase

The App uses Firebase to authenticate with a phone number and to send & store votes:
https://console.firebase.google.com

## Firebase Login with Phone number
### Android
https://firebase.google.com/docs/auth/android/phone-auth?authuser=1

### iOS
https://firebase.google.com/docs/auth/ios/phone-auth?authuser=1


## Get Countries

There is a `countries` collection.

Countries should be fetched on App start and kept in cache.

The `documentID` of the Firebase model is the `countryCode`.

For example:

`documentID` = "FR"  
data =
```swift
[ "name" : "France" ]
```
## Get Songs

There is a `songs` collection.

Example song:
```swift
[
  "title" : "Hooverphonics - Release Me"
  "countryCode" : "BE"
]
```
