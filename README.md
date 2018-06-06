# OneSky SDK
> Online localization resolver.

One Sky manager implement online localization for iOS application. SDK simply create .strings files in your application. 

You can watch video here:

[![Watch the video](https://raw.github.com/GabLeRoux/WebMole/master/ressources/WebMole_Youtube_Video.png)](https://monosnap.com/file/aOzgPhrEiDCSGYghgJhS2qZ6rRUYtf)


## Features

- [x] Swift 4.1
- [x] Cocoapods
- [x] Xcode 9

## Requirements

- iOS 10.0+
- Xcode 8.0+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `OneSky` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!
pod 'OneSky', :podspec => '/Users/{yourUser}/{yourProject}/onesky-sdk-ios'
```
#### Because this repository is private, I can't fully upload it to cocoapods, but it is using cocoapods now:
#### Download this project, and realise the way to folder `'/Users/{yourUser}/{yourProject}/onesky-sdk-ios'` where is project's `.podspec` file located. 
#### That's will download framework through cocoapods by your local .podspec

To get the full benefits import `OneSky`

``` swift
import OneSky
```

## Usage example

There are two ways of using framework. For both you need to implement:

``` swift
fileprivate var localizationManager: OneSkyManager? = OneSkySource()
```

You should implement localization in `override func viewWillAppear(animated:)` function, like: 
``` swift
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        firstLabel.text = "top".localized
        secondLabel.text = "ask".localized
        ...
    }
 ``` 
where `.localized` extension is our framework feauture.

#### Then:

- ###  With UI
 If you are going to use framework custom Settings UI then you need to implement the code below in your button handler.
 ``` swift
   // your Button handler
  func buttonPressed() {
    localizationManager?.open(from: self, style: .push)
  }
 ```
 This code implement delegate method ehich open OneSky custom UI. Available styles:
 
 -  **.push** - Implement `push` presentation style (your viewController should have navigationController in stack) 
 -  **.present** - Implement simple `present` presentation style
 
 ##### If you want to use `userId` then write this code below:
 
  ``` swift
  // your Button handler
  func buttonPressed() {
    localizationManager?.open(from: self, style: .push, userId: userId) // where userId: Int value of your user id 
  }
 ```
 
 There is no need to do smth else. Framework will make everything by his own.
 

- ###  Endpoints only

If you want to use endpoint only, there is a short guide of available delegate methods.

- `weak var delegate: OneSkyDelegate? { get set }` - Implement delegate, which implements the methods that the SDK returns. More details can be found in the documentation in the code.
- `var currentLanguageCode: String? { get }` - Returns current device language locale code

- `func getAvailableLocales()` - Makes a request for a common application configuration. For now using hardcode `AppId`.
- `func getUserPreferences(with userId: Int)` - Makes a request for a specific user preference.
- `func sendUserSettings(with userId: Int, preferences: UserSettings)` - Makes a POST request to upload specific user preference. Also use it to create a new user!
- `func translate(locale: Locales)` - Translate text and save new .strings file in the new Bundle. You must pass `Locales` structure in the parameters of function. Structure should implement the language you want TO translate.

## Offline working
Actually, your application download configuration files and locales on compilation stage. To configure the offline mode, you must:

- Add `Run script` in `Build phases` :
``` PHP
    MYFILE=${SRCROOT}/OneSkyTestApp/Modules/Api/configuration.json
curl -o $MYFILE https://app-api.oneskyhq-stag.com/v1/apps/cfad03c9-0071-4de4-a58c-71a0d4cd9f31 #route
cp "${SRCROOT}/OneSkyTestApp/Modules/Api/configuration.json"  "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/configuration.json"
```
where `cfad03c9-0071-4de4-a58c-71a0d4cd9f31` is **Your App id** and `/OneSkyTestApp/Modules/Api/` - is path where you want to save configuration file.

- Add one more script in `Build phases` :
``` PHP
    php ./OneSkyTestApp/Modules/API/configuration.php -- "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/"
```
where `configuration.php` - **pre-prepared** file. In your `configuration.php` file copy the code below:
``` PHP
    <?php
    $arg = $argv[2];
    echo "arg = " . $arg . "\n";
    $json_url = "https://app-api.oneskyhq-stag.com/v1/apps/cfad03c9-0071-4de4-a58c-71a0d4cd9f31";
    $json = file_get_contents($json_url);
    $data = json_decode($json, TRUE);
    $localesArray = array();
    $locales = $data['app']['selectors'][0]['locales'];
    foreach($locales as $item) {
        array_push($localesArray, $item['id']);
    }
    
    print_r($localesArray);

    # now get string files
    $new_url = "https://app-api.oneskyhq-stag.com/v1/apps/cfad03c9-0071-4de4-a58c-71a0d4cd9f31/string-files?fileFormat=ios-strings&languageId=";

    foreach($localesArray as $id) {
        $url = $new_url . $id;
        $data = file_get_contents($url);
        echo "data = " . $data . "\n";
        file_put_contents($arg . 'Localizable-' . $id . '.strings', $data);
    }
?>
```
where `cfad03c9-0071-4de4-a58c-71a0d4cd9f31` is **Your App id**.
Thats all!

## You can see usage example in `Hacker-master` project in the main folder.
