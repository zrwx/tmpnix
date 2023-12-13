{
  enable = true;

  config = {
    profile = "gpu-hq";
    force-window = true;
    ytdl-format = "bestvideo+bestaudio";


    hwdec = "auto-safe";
    save-position-on-quit = true;
    loop = "inf";
    pause = true;
    force-seekable = true;

    cache = true;
    cache-secs = 300;
    cache-default = 4000000;

    priority = "high";
    snap-window = true;

    # sets fast seeking:
    demuxer-max-back-bytes = "20M";
    demuxer-max-bytes = "20M";

    # sets the video leanguage
    vlang = "en,eng";

    # sets the video out to an experimental video renderer based on libplacebo
    vo = "gpu-next";

    prefetch-playlist = true;

    hls-bitrate = "max";
  };

  bindings = {
    l = "seek 5";
    h = "seek -5";
    j = "seek 60";
    k = "seek -60";
    s = "cycle sub";
    S = "cycle sub down";
    PGUP = "add chapter -1";
    PGDWN = "add chapter 1";
    "Ctrl+l" = "ab-loop";
    WHEEL_UP = "seek 10";
    WHEEL_DOWN = "seek -10";
    "Alt+0" = "set window-scale 0.5";
    "Alt+-" = "add video-zoom -0.1";
    "Alt+=" = "add video-zoom +0.1";
    "Alt+h" = "add video-pan-x -0.1";
    "Alt+l" = "add video-pan-x 0.1";
    "Alt+j" = "add video-pan-y 0.1";
    "Alt+k" = "add video-pan-y -0.1";
  };
}