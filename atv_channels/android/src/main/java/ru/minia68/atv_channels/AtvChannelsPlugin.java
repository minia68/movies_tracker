package ru.minia68.atv_channels;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.res.Resources;
import android.database.Cursor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry;

import androidx.tvprovider.media.tv.Channel;
import androidx.tvprovider.media.tv.PreviewChannel;
import androidx.tvprovider.media.tv.PreviewChannelHelper;
import androidx.tvprovider.media.tv.PreviewProgram;
import androidx.tvprovider.media.tv.TvContractCompat;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

/**
 * AtvChannelsPlugin
 */
public class AtvChannelsPlugin implements FlutterPlugin, Messages.AtvChannelsApi,
        PluginRegistry.NewIntentListener, ActivityAware {
    private static final String TAG = "AtvChannelsPlugin";
    private static final String APP_BASE_URI_KEY = "app_base_uri";
    private static final String APP_CHANNEL_URI_PATH = "channel";
    private static final String APP_PROGRAM_URI_PATH = "program";
    private String initialChannelExternalId;
    private String initialProgramExternalId;
    private Context context;
    private Messages.AtvChannelsApiFlutter atvChannelsApiFlutter;
    private Activity activity;
    private Receiver receiver;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onAttachedToEngine");
        context = binding.getApplicationContext();
        atvChannelsApiFlutter = new Messages.AtvChannelsApiFlutter(binding.getBinaryMessenger());
        Messages.AtvChannelsApi.setup(binding.getBinaryMessenger(), this);

        receiver = new Receiver();
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addCategory(Intent.CATEGORY_DEFAULT);
        intentFilter.addAction(TvContractCompat.ACTION_PREVIEW_PROGRAM_BROWSABLE_DISABLED);
        context.registerReceiver(receiver, intentFilter);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "onDetachedFromEngine");
        if (context == null) {
            Log.wtf(TAG, "Detached from the engine before registering to it.");
        } else {
            context.unregisterReceiver(receiver);
        }
        Messages.AtvChannelsApi.setup(binding.getBinaryMessenger(), null);
        receiver = null;
        context = null;
        atvChannelsApiFlutter = null;
    }

    @Override
    public boolean onNewIntent(Intent intent) {
        return handleIntent(intent, false);
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        Log.d(TAG, "onAttachedToActivity");
        binding.addOnNewIntentListener(this);
        handleIntent(binding.getActivity().getIntent(), true);
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity");
        activity = null;
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addOnNewIntentListener(this);
    }

    @Override
    public Messages.CreateResponse createChannel(Messages.CreateChannelRequest arg) {
        PreviewChannel.Builder builder = new PreviewChannel.Builder();
        builder.setDisplayName(arg.getName())
                .setInternalProviderId(arg.getExternalId())
                .setLogo(resourceUri(context.getResources(), getResourceFromContext(
                        context, "drawable", arg.getLogoDrawableResourceName())))
                .setAppLinkIntentUri(Uri.parse(
                        String.format(
                                "https://%s/%s/%s",
                                context.getString(getResourceFromContext(
                                        context, "string", APP_BASE_URI_KEY)),
                                APP_CHANNEL_URI_PATH,
                                arg.getExternalId())));

        long id;
        try {
            if (arg.getDefaultChannel()) {
                id = new PreviewChannelHelper(context).publishDefaultChannel(builder.build());
            } else {
                id = new PreviewChannelHelper(context).publishChannel(builder.build());
            }
        } catch (IOException e) {
            throw new RuntimeException();
        }

        Messages.CreateResponse response = new Messages.CreateResponse();
        response.setId(id);
        return response;
    }

    @Override
    public void deleteChannel(Messages.DeleteRequest arg) {
        new PreviewChannelHelper(context).deletePreviewChannel(arg.getId());
    }

    @Override
    public Messages.CreateResponse createProgram(Messages.CreateProgramRequest arg) {
        PreviewProgram.Builder builder = new PreviewProgram.Builder();
        buildProgram(builder, arg);
        long id = new PreviewChannelHelper(context).publishPreviewProgram(builder.build());

        Messages.CreateResponse response = new Messages.CreateResponse();
        response.setId(id);
        return response;
    }

    @Override
    public void updateProgram(Messages.CreateProgramRequest arg) {
        PreviewProgram.Builder builder = new PreviewProgram.Builder();
        buildProgram(builder, arg);

        new PreviewChannelHelper(context).updatePreviewProgram(arg.getProgramId(), builder.build());
    }

    @Override
    public void deleteProgram(Messages.DeleteRequest arg) {
        new PreviewChannelHelper(context).deletePreviewProgram(arg.getId());
    }

    @Override
    public Messages.GetInitialDataResponse getInitialData() {
        Messages.GetInitialDataResponse response = new Messages.GetInitialDataResponse();
        response.setChannelExternalId(initialChannelExternalId);
        response.setProgramExternalId(initialProgramExternalId);
        initialChannelExternalId = null;
        initialProgramExternalId = null;
        return response;
    }

    @SuppressLint("RestrictedApi")
    @Override
    public Messages.GetChannelsResponse getChannels() {
        try (Cursor cursor = context.getContentResolver()
                .query(
                        TvContractCompat.Channels.CONTENT_URI,
                        Channel.PROJECTION,
                        null,
                        null,
                        null)) {
            if (cursor != null && cursor.moveToFirst()) {
                ArrayList channels = new ArrayList();
                do {
                    Channel channel = Channel.fromCursor(cursor);
                    Messages.Channel messageChannel = new Messages.Channel();
                    messageChannel.setId(channel.getId());
                    messageChannel.setExternalId(channel.getInternalProviderId());
                    messageChannel.setIsBrowsable(channel.isBrowsable());
                    messageChannel.setTitle(channel.getDisplayName());
                    channels.add(messageChannel.toMap());
                } while (cursor.moveToNext());
                Messages.GetChannelsResponse response = new Messages.GetChannelsResponse();
                response.setChannels(channels);
                return response;
            } else {
                Messages.GetChannelsResponse response = new Messages.GetChannelsResponse();
                response.setChannels(new ArrayList());
                return response;
            }
        }
    }

    @SuppressLint("RestrictedApi")
    @Override
    public Messages.GetProgramsIdsResponse getProgramsIds(Messages.GetProgramsIdsRequest arg) {
        try (Cursor cursor = context.getContentResolver()
                .query(
                        TvContractCompat.PreviewPrograms.CONTENT_URI,
                        PreviewProgram.PROJECTION,
                        null,
                        null,
                        null)) {
            if (cursor != null && cursor.moveToFirst()) {
                ArrayList ids = new ArrayList();
                do {
                    PreviewProgram program = PreviewProgram.fromCursor(cursor);
                    if (program.getChannelId() == arg.getChannelId()) {
                        ids.add(program.getId());
                    }
                } while (cursor.moveToNext());
                Messages.GetProgramsIdsResponse response = new Messages.GetProgramsIdsResponse();
                response.setProgramsIds(ids);
                return response;
            } else {
                Messages.GetProgramsIdsResponse response = new Messages.GetProgramsIdsResponse();
                response.setProgramsIds(new ArrayList());
                return response;
            }
        }
    }

    @Override
    public void setChannelBrowsable(Messages.SetChannelBrowsableRequest arg) {
        if (activity != null) {
            Intent intent = new Intent(TvContractCompat.ACTION_REQUEST_CHANNEL_BROWSABLE);
            intent.putExtra(TvContractCompat.EXTRA_CHANNEL_ID, arg.getId());
            activity.startActivityForResult(intent, 0);
        }
    }

    @Override
    public void dummy(Messages.Channel arg) {
    }

    private void buildProgram(PreviewProgram.Builder builder, Messages.CreateProgramRequest arg) {
        builder.setChannelId(arg.getChannelId())
                .setType(arg.getType().intValue())
                .setTitle(arg.getTitle())
                .setDescription(arg.getDescription())
                .setPosterArtUri(Uri.parse(arg.getPosterArtUri()))
                .setPosterArtAspectRatio(arg.getPosterArtAspectRatio().intValue())
                .setReviewRating(arg.getReviewRating())
                .setReviewRatingStyle(arg.getReviewRatingStyle().intValue())
                .setReleaseDate(arg.getReleaseDate())
                .setInternalProviderId(arg.getExternalId())
                .setIntentUri(Uri.parse(
                        String.format(
                                "https://%s/%s/%s/%s",
                                context.getString(getResourceFromContext(
                                        context, "string", APP_BASE_URI_KEY)),
                                APP_PROGRAM_URI_PATH,
                                arg.getChannelExternalId(),
                                arg.getExternalId())));
    }

    private boolean handleIntent(Intent intent, boolean initial) {
        if (Objects.equals(intent.getAction(), Intent.ACTION_VIEW)) {
            Uri uri = intent.getData();
            Log.d(TAG, String.format(
                    "Intent %s received: %s",
                    intent.getAction(),
                    uri != null ? uri.toString() : "null"));
            if (uri == null) {
                return false;
            }
            switch (uri.getPathSegments().get(0)) {
                case APP_CHANNEL_URI_PATH:
                    String channelId = uri.getLastPathSegment();
                    Log.d(TAG, "Navigating to browser for channel " + channelId);
                    if (initial) {
                        initialChannelExternalId = channelId;
                    } else {
                        Messages.ShowRequest request = new Messages.ShowRequest();
                        request.setChannelExternalId(channelId);
                        atvChannelsApiFlutter.showChannel(request, reply -> {
                        });
                    }
                    return true;
                case APP_PROGRAM_URI_PATH:
                    List<String> pathSegments = uri.getPathSegments();
                    int pathSegmentsLength = pathSegments.size();
                    String programId = pathSegments.get(pathSegmentsLength - 1);
                    channelId = pathSegments.get(pathSegmentsLength - 2);
                    Log.d(TAG, "Navigating to browser for program " + programId);
                    if (initial) {
                        initialProgramExternalId = programId;
                        initialChannelExternalId = channelId;
                    } else {
                        Messages.ShowRequest request = new Messages.ShowRequest();
                        request.setChannelExternalId(channelId);
                        request.setProgramExternalId(programId);
                        atvChannelsApiFlutter.showProgram(request, reply -> {
                        });
                    }
                    return true;
                default:
                    Log.w(TAG, String.format(
                            "VIEW intent received but unrecognized URI: %s", uri.toString()));
                    return false;
            }
        }
        return false;
    }

    //https://stackoverflow.com/questions/56379421/how-to-access-android-resource-strings-from-flutter-plugin
    private static int getResourceFromContext(
            @NonNull Context context, String resType, String resName) {
        final int res = context.getResources().getIdentifier(
                resName, resType, context.getPackageName());
        if (res == 0) {
            throw new IllegalArgumentException(String.format(
                    "The 'R.%s.%s' value it's not defined in your project's resources file.",
                    resType, resName));
        }
        return res;
    }

    private static Uri resourceUri(Resources resources, int id) {
        return new Uri.Builder()
                .scheme(ContentResolver.SCHEME_ANDROID_RESOURCE)
                .authority(resources.getResourcePackageName(id))
                .appendPath(resources.getResourceTypeName(id))
                .appendPath(resources.getResourceEntryName(id))
                .build();
    }

    static class Receiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            Log.d(TAG, "onReceive " + intent.getAction());
            if (TvContractCompat.ACTION_PREVIEW_PROGRAM_BROWSABLE_DISABLED.equals(intent.getAction())) {
                Bundle bundle = intent.getExtras();
                if (bundle != null) {
                    long programId = bundle.getLong(TvContractCompat.EXTRA_PREVIEW_PROGRAM_ID);
                    new PreviewChannelHelper(context).deletePreviewProgram(programId);
                }
            }
        }
    }
}
