# AIOS_assessment3_app2

Authors:
Yu-Teng Lan (UTS Student ID: 24906378)

Introduction:
The app is called Daily Speech. It encourages users to practice speaking in the language they want to improve. Users can decide whether to share their speeches and audio recordings with others.

Instructions:
1. Open the app with Xcode.
2. Add the Firebase iOS SDK package:
3. File -> Add Package Dependencies... -> search for https://github.com/firebase/firebase-ios-sdk
-> select FirebaseAnalytics, FirebaseAuth, FirebaseFirestore, FirebaseStorage -> Add Package.
4. Run the app.
5. Sign up for an account by entering your email and password.
Or sign in with a test account:
    test1@test.com / 12345678
    test2@test.com / 12345678
6. Start practicing: Enter your topic or pick a topic from the list below -> Ready to Speak.
7. Enter your speech or click the microphone icon to generate words from your talk -> Revise by AI.
8. You can replay your audio and modify your revised speech -> Click save -> The revised speech and audio will be saved.
9. You can review your previous practices and share them with others.
10. You can go to "Shared Speeches" to see your shared speeches and others' shared speeches.
11. Keep practicing, and you will become fluent in the language!

Error Handling Strategy for Daily Speech App
In the Daily Speech app, ensuring a smooth user experience involves anticipating potential errors and implementing strategies to handle them effectively.

1. Input Error Checks: account password validation, topic and content not left bank.
2. API Failures: API failures can result from network issues, timeouts, or invalid API responses.
3. Access to microphone failures: For speech recognition and recording, access to microphone sometimes can fail because of permission.
4. Local Data Save Failures: Out of storage, data corruption.
5. Firebase Cloud Save Failures: Permission, data conflicts.

Resources:
1. Firebase: https://firebase.google.com
2. OpenAIAPI: https://openai.com/index/openai-api/

