#!/usr/bin/env -S osascript -l JavaScript

ObjC.import('AppKit')

function getVLCTitle() {
  const app = Application("VLC");
  if (!app.running()) return null;

  try {
    if (!app.playing()) return null; // só se estiver tocando
  } catch (e) {
    return null;
  }

  try {
    return app.windows[0].name();
  } catch (e) {
    return null;
  }
}

function getSystemNowPlaying(infoDict) {
  const title = infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoTitle');
  const artist = infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoArtist');

  return `${title.js} - ${artist.js}`;
}

function getMenuBarText(playing, isPlaying) {
  const playingIcon = isPlaying ? '􀊗' : '􀊕';
  return `${playingIcon} ${playing}`;
}

function run() {
  const MediaRemote = $.NSBundle.bundleWithPath('/System/Library/PrivateFrameworks/MediaRemote.framework/');
  MediaRemote.load
  const MRNowPlayingRequest = $.NSClassFromString('MRNowPlayingRequest');
  const infoDict = MRNowPlayingRequest.localNowPlayingItem.nowPlayingInfo;
  const vlcTitle = getVLCTitle();
  if (vlcTitle) {
    return getMenuBarText(vlcTitle, true);
  }
  if (!infoDict) {
    return getMenuBarText('Nothing playing', false);
  }
  const isPlaying = infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoPlaybackRate').js == 1;

  const playing = getSystemNowPlaying(infoDict);
  // return `${getMenuBarText(playing, isPlaying)}\n---\n${JSON.stringify(infoDict, null, 2)}\n${vlcTitle}\n${infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoPlaybackRate').js}`;
  return getMenuBarText(playing, isPlaying);
}
