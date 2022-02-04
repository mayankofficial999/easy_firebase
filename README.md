## Introduction
<code> easy_firebase</code> helps you to quickly implement various firebase functionalities and saves you time to focus on the UI.

## Features
This package contains the following functionalities : 
<details><summary>
1) Authentication </summary>  

- Google Sign-in
- Email Sign up / Sign in
- Mail Verification
- OTP Sign-In
- Delete Mail User
- Anonymous Sign in
- Sign out
- Facebook Sign-in/Sign out </details> 
<details><summary>
2) Firestore </summary>  

- CRUD (Create,Read,Update,Delete) for a given collection and document.
- Firestore Object for custom or nested collections/documents.</details> 
<details><summary>
3) Realtime Database </summary> 

- CRUD (Create,Read,Update,Delete) for a given node path and data as Map object.</details>  
<details><summary>
4) Firebase Storage </summary>

- List of all items for a specified path.
- List of all items with a limit.
- Get downloadUrl for a file with specified path.
- Upload a File from assets.
- Upload a string data.
- Get the metafile of a specified file.
- Download a file to app package location.</details>

<br>

## Getting started
Set up the needed firebase functionalities and follow the steps to use the package :
<details>
<summary>
Android   </summary>  

* Create a firebase project  
* Set up the functionality you wish to use ie. Realtime Database, Firestore, Authentication or Storage.  
* <b>Note</b> : Firstly set up all the functionality on firebase console, after this only add an app to the console.  
* Now click on add android application and follow the steps to setup firebase. And add android’s SHA1 and SHA256 key to firebase.  
You can get SHA keys by (you are in flutter app folder) :  
    ```
    cd android
	./gradlew signingReport
    ```
* To use this project add these lines :  
In app level build.gradle :
    ```
    DefaultConfig {
        ...
    	minSdkVersion 19
        multiDexEnabled true
        ...
    }  

    dependencies{  
    	...
    	//Add these lines
    	implementation 'com.google.firebase:firebase-auth-ktx'
        implementation 'com.android.support:multidex:1.0.3'
        ...
    }
    ```

* In project level build.gradle:
    ```
	buildscript {
		…
		//Update the line to this
   		ext.kotlin_version = '1.4.32'
		…
		}
    ```  

	And in  <code>android/gradle/wrapper/gradle-wrapper.properties </code>,  
	Replace the existing line with this:  
    ```
		distributionUrl=https\://services.gradle.org/distributions/gradle-6.9-all.zip
    ```
* The project is now ready for OTP Login,Google,Email and Anonymous Sign In.  

* For using Facebook sign in :  
Note : Do not use flutter_facebook_login package , this package uses flutter_login_facebook .
Go to https://developers.facebook.com/docs/facebook-login/android and follow only Steps 1,3 ,4 , 5 and 6. [ And use the hashes in facebook dev portal ].  
* For the strings.xml , use this template and update the code.  
    ```
    <?xml version="1.0" encoding="utf-8"?>
    <resources>
        <string name="app_name">Your App Name here.</string>

        <!-- Replace "000000000000" with your Facebook App ID   here. -->
        <string name="facebook_app_id">000000000000</string>

        <!--
          Replace "000000000000" with your Facebook App ID here.
          **NOTE**: The scheme needs to start with `fb` and then    your ID.
        -->
        <string name="fb_login_protocol_scheme">fb000000000000</    string>
    </resources>
    ```
* Add the given OAuth redirect URI on firebase console to your Facebook app configuration  
Now your app is ready for facebook login.
</details>  
<br>
<details>
<summary>
iOS   </summary>  

* Create a firebase project
* Set up the functionality you wish to use ie. Realtime Database, Firestore, Authentication or Storage.
    * Note : Firstly set up all the functionality on firebase console, after this only add an app to the console.
Now click on add android application and follow the steps to setup firebase.  
* <b>Warning :</b> Do not add firebase-ios-sdk to your workspace to your xcode workspace , it will work without this.
* After you have place google-services.plist in Xcode,  
Add these lines to info.plist for google_sign_in :  
    ```
    <!-- Put this in the [my_project]/ios/Runner/Info.plist file -->
    <!-- Google Sign-in Section -->
    <key>CFBundleURLTypes</key>
    <array>
    	<dict>
    		<key>CFBundleTypeRole</key>
    		<string>Editor</string>
    		<key>CFBundleURLSchemes</key>
    		<array>
    			<!-- TODO Replace this value: -->
    			<!-- Copied from GoogleService-Info.plist key   REVERSED_CLIENT_ID -->
    			<string>com.googleusercontent.apps. 861823949799-vc35cprkp249096uujjn0vvnmcvjppkn</  string>
    		</array>
    	</dict>
    </array>
    <!-- End of the Google Sign-in Section →

    ```  
* Set min iOS version to 12 for the entire workspace.
* The project is now ready for OTP Login,Google,Email and Anonymous Sign In  

* For using Facebook sign in :
    * <b>Note :</b> Do not use flutter_facebook_login package , this package uses flutter_login_facebook .  
* Go to https://developers.facebook.com/docs/facebook-login/ios and follow only Steps 1,3 ,4 ,and 5. [ And use the hashes in facebook dev portal ].  
    * <b>Note :</b> If you’re using both google-sign in and facebook , you should put the CFBundleURLSchemes in the same CFBundleURLTypes.  
  
    Sample plist code block :
    ```
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <string><Reverse_Client_Id></string>
            </array>
        </dict>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
              <string>fd<APP_ID></string>
            </array>
        </dict>
    </array>
    <key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>
    <key>UIFileSharingEnabled</key>
    <true/>
    ```
* Now your iOS app is ready for facebook login.
* <b>Note</b> : For m1 macbook users , before running the app , 
	Open Xcode Workspace located in ios/Runner folder,set all targets to min iOS 12.
	In the terminal :
    ```
		cd ios
		sudo arch -x86_64 gem install ffi
		arch -x86_64 pod install
    ```

</details>  
<br>  

## Usage

An example project can be found in the <code>sample_example</code> folder of the repository.  
```
// Import this in your code
import 'package:firebase_core/firebase_core.dart';
```  
and   
```
// Add this your main function
void main() {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(); 
 ...
}
```
To use any of the functionalities you just have to create an object of it , for eg : 
```
var auth = EasyFire().getAuthObject();
var store = EasyFire().getAuthObject();
var rtdb = EasyFire().getAuthObject();
var storage = EasyFire().getAuthObject();

//To login with google 
auth.signInWithGoogle();

//To send data to Firestore Database
store.setData('Users','id_123',{'data':123});

//To send data to RTDB Database
rtdb.setData('/data',{'name':'sample'});

//To download a file from Firebase Storage
storage.downloadFile(
    firestorePath: '/images/demo.jpg',
    'imageSaved.png'
);

```

## Contribution and Issues  
* To report issues , go to this [repo](link) , and open an new issue.
* If you want to contribute to this package , then open a new pull request with the functionality which you implemented and get it merged.
