#!/usr/bin/env -S osascript -l JavaScript

function run() {
  const MediaRemote = $.NSBundle.bundleWithPath('/System/Library/PrivateFrameworks/MediaRemote.framework/');
  MediaRemote.load

  const MRNowPlayingRequest = $.NSClassFromString('MRNowPlayingRequest');

  const infoDict = MRNowPlayingRequest.localNowPlayingItem.nowPlayingInfo;
  if (!infoDict) {
    return ""
  }
  const isPlaying = infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoPlaybackRate').js == 1;
  const playingIcon = isPlaying ? '􀊗' : '􀊕'

  const title = infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoTitle');
  const artist = infoDict.valueForKey('kMRMediaRemoteNowPlayingInfoArtist');

  const playing = `${title.js} - ${artist.js}`;
  return `${playingIcon} ${playing} | length=50`;
}

console.log(run());
