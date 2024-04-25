## Introduction
<code> easy_firebase</code> helps you to quickly implement various firebase functionalities and saves you time to focus on the UI.

## Getting started
Set up the needed firebase functionalities and follow the steps to use the package :
<details>
<summary>
Android   </summary>  

- Create a firebase project
- Install & setup <code>Firebase CLI</code> by following this [guide](https://firebase.google.com/docs/flutter/setup?platform=ios)

- Set up the functionality you wish to use.
  - Realtime Database
  - Firestore
  - Authentication
  - Storage.  
 
- Now click on add android application and follow the steps to setup firebase. And add android’s SHA1 and SHA256 key to firebase.  
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

* The project is now ready for :
    - OTP Login
    - Google Signin
    - Email Authentication
    - Anonymous Sign In

- For using <code>Facebook sign in</code> :   
<br>
<b>Note :</b> Do not use flutter_facebook_login package , this package uses flutter_login_facebook .
Go to this [guide](https://developers.facebook.com/docs/facebook-login/android) and follow only Steps 1,3 ,4, 5 and 6. [ And use the hashes in facebook dev portal ].  
<br>
* For the <code>strings.xml</code> , use this template and update the code.  
<br>
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
* Add the given <code>OAuth</code> redirect URI on firebase console to your Facebook app configuration  
Now your app is ready for facebook login.
</details>  
<br>
<details>
<summary>
iOS   </summary>  

- Create a firebase project
- Install & setup <code>Firebase CLI</code> by following this [guide](https://firebase.google.com/docs/flutter/setup?platform=ios)
- Set up the functionality you wish to use.
    - Realtime Database
    - Firestore
    - Authentication
    - Storage.  
 
- Add these lines to <code>Info.plist</code> for <code>google_sign_in</code> :  
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
- Set min <code>iOS version to 12</code> for the entire workspace.
- The project is now ready for:
    - OTP Login
    - Google Sign In
    - Email Authentication
    - Anonymous Sign In  

- For using Facebook sign in :
    * <b>Note :</b> Do not use <code>flutter_facebook_login</code> package , this package uses <code>flutter_login_facebook</code>.  
* Go to this [guide](https://developers.facebook.com/docs/facebook-login/ios) and follow only Steps 1, 3, 4 and 5. [ And use the hashes in facebook dev portal ].  
    * <b>Note :</b> If you’re using both <code>google-sign</code> in and <code>facebook</code> , you should put the <code>CFBundleURLSchemes</code> in the same <code>CFBundleURLTypes</code>.  
<br>
* <u>Sample plist code block :</u>  
<br>  
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
- Now your iOS app is ready for <code>facebook</code> login.


</details>  
<br>  


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
- Upload a File from device or assets.
- Upload a string data.
- Get the metafile of a specified file.
- Download a file.</details>

<br>

## Usage

An example project can be found in the <code>sample_example</code> folder of the repository.  
```
// Import this in your code
import 'package:firebase_core/firebase_core.dart';
import 'package:example/firebase_options.dart';
```  
and   
```
// Add this your main function
void main() {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); 
 ...
}
```
To use any of the functionalities you just have to create an object of it , for eg : 
```
var auth = EasyFire().getAuthObject();
var store = EasyFire().getFirestoreObject();
var rtdb = EasyFire().getRtdbObject();
var storage = EasyFire().getStorageObject();

//To login with google 
auth.signInWithGoogle();

//To send data to Firestore Database
store.setData('Users','id_123',{'data':123});

//To send data to RTDB Database
rtdb.setData('/data',{'name':'sample'});

// To download a file (opens a file picker)
storage.downloadFile(firestorePath: '/sample.png');

// To upload a file (opens file picker)
storage.uploadFile();

```

## Contribution and Issues  
* To report issues , go to this [repo](https://github.com/mayankofficial999/easy_firebase.git) , and open an new issue.
* If you want to contribute to this package , then open a new pull request with the functionality which you implemented and get it merged.
