<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <application>
    <#if addJumpActivity>
        <activity android:name="${relativePackage}.JumpActivity"/>
    </#if>

        <activity android:name="${relativePackage}.SetupActivity">
        <#if !(isLibraryProject!false) && isLauncher>
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </#if>
        </activity>
    </application>

</manifest>
