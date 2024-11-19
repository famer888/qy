package com.example.android_dynamic_icon;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;

import androidx.annotation.NonNull;
import java.util.logging.*;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.List;


/** AndroidDynamicIconPlugin */
public class AndroidDynamicIconPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;

    private static List<String> classNames = null;

    private static boolean iconChanged = false;

    private static final String TAG = "[android_dynamic_icon]";

    public static String getTAG() {
        return TAG;
    }



    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "AndroidDynamicIcon");
        context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }


    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "initialize":
            {
                classNames = call.arguments();
                break;
            }
            case "changeIcon":
            {
                changeIcon(call);
                break;
            }
            default:
                result.notImplemented();
                break;
        }
    }

    private void changeIcon(MethodCall call) {
        if(classNames == null || classNames.isEmpty()) {
            Log.e(TAG,"Initialization Failed!");
            Log.i(TAG,"List all the activity-alias class names in initialize()");
            return;
        }

        if (!iconChanged){
            iconChanged = true;
            List<String> args = call.arguments();

            String className = args.get(0);
            PackageManager pm = context.getPackageManager();
            String packageName = context.getApplicationInfo().packageName;
            int componentState = PackageManager.COMPONENT_ENABLED_STATE_DISABLED;
            int i=0;
            for(;i<classNames.size();i++) {
                ComponentName cn = new ComponentName(packageName, packageName+"."+classNames.get(i));
                int status = pm.getComponentEnabledSetting(cn);


                if(className.equals(classNames.get(i))) {
                    componentState = PackageManager.COMPONENT_ENABLED_STATE_ENABLED;
                }
                else if((i == 0 && status == PackageManager.COMPONENT_ENABLED_STATE_DEFAULT) || status == PackageManager.COMPONENT_ENABLED_STATE_ENABLED){
                    componentState = PackageManager.COMPONENT_ENABLED_STATE_DISABLED;
                }
                else {
                    continue;
                }
                pm.setComponentEnabledSetting(cn, componentState, PackageManager.DONT_KILL_APP);
            }

            if(i>classNames.size()) {
                Log.e(TAG,"class name "+className+" did not match in the initialized list.");
                return;
            }
            iconChanged = false;
            Log.d(TAG,"Icon switched to "+className);
        }
    }


    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
