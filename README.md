# eway project


## Project Structure

- MVVM pattern.
- Using provider package: https://pub.dev/packages/provider, version ^3.0.0+1

## Project detail - break down by package
#####  Network call and local db
-  API call lib: https://pub.dev/packages/dio
- Local data lib: https://pub.dev/packages/sqflite
- When you create new API provider class, it must be extend from ```BaseApiProvider``` class. And then register it in ```locator.dart```  file.
-  When you create new repository  class, it must be extend from ```BaseRepository``` class. And then register it in ```locator.dart```  file.

##### Dependency injection(DI) set up
- Package: https://pub.dev/packages/get_it
- All DI set up will be in ```locator.dart```

##### Set up multi language
- Step 1: Define your message in ```i18n_en.json``` and ```i18n_vi.json```
- Step 2: Mapping your key ( step 1) to ```app_lang.dart```
- Step 3: Using ```AppTranslations``` class to get message.
- Visit ```main.dart```  and ```localization``` package to learn more about setup multi language
##### Add new image resource to project
- Step 1: Copy your image to  ```\assets\images```
- Step 2: Mapping image name to ```app_drawable.dart```

##### Add new screen to project
- Step 1: Visit ```template\create_new_screen_mvvm``` to  create new screen
- Step 2: We are using https://pub.dev/packages/route_annotation to generate flutter screen routing.
- Step 3:From root of project,  run this line to generate code:  ```flutter packages pub run build_runner build --delete-conflicting-outputs```
- Note: All screen must be extended from ```BaseScreen```, all model class will be extend ```BaseViewModel``` class.

##### Add new data class ( for request and response api)
- Step 1: Visit ```template\create_object_template``` to  create new object
- Step 2 :From root of project,  run this line to generate code:  ```flutter packages pub run build_runner build --delete-conflicting-outputs```

##### Custom your widget
- All custom widget will be in ```widget``` package and must be end by _widget (Ex: ```app_appbar_widget.dart```).

##### Logger
- Must use ```AppLogger``` class to write your log.

##### IDE
- Android Studio
- VS
##### Deploy:
- Android: Using android studio to open ```\android``` folder  and build the same with native platform
- iOS: Using xcode to open ```\ios``` folder and build the same with native platform.


pub global activate devtools