package net.people.flutterapp.plugins;

import android.content.Context;
import android.widget.Toast;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class ToastProviderPlugin {


    private static final String ChannelName = "toast";

    public static void register(final Context context, BinaryMessenger messenger) {

        MethodChannel methodChannel = new MethodChannel(messenger, ChannelName);

        methodChannel.setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                String method = methodCall.method;
                String msg = null;
                Object message = methodCall.argument("message");
                if (message instanceof String) {
                    msg = (String) message;
                } else {
                    result.error("type is no String", "type is no String", message.getClass().getComponentType());
                }
                if (msg == null) {
                    return;
                }
                if ("short".equals(method)) {
                    showToast(context, msg, Toast.LENGTH_SHORT);
                } else if ("long".equals(method)) {
                    showToast(context, msg, Toast.LENGTH_LONG);
                } else {
                    result.success(null);
                }
            }
        });
    }

    private static void showToast(Context context, String msg, int duration) {
        Toast.makeText(context, msg, duration).show();
    }

}


