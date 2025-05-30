{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.moduleopts.wtf;
in
{
  options.moduleopts.wtf = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "wtf";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.wtfutil
    ];
    xdg.configFile."wtf/config.yml".text = ''
      wtf:
        colors:
          border:
            focusable: darkslateblue
            focused: orange
            normal: gray
          checked: yellow
          highlight:
            fore: black
            back: gray
          rows:
            even: yellow
            odd: white
        grid:
          columns: [40, 40, 35, 35, 35, 50]
          rows: [10, 7, 10, 10, 0]
        refreshInterval: 1
        openFileUtil: "open"
        mods:
          europe_time:
            title: "Europe"
            type: clocks
            colors:
              rows:
                even: "lightblue"
                odd: "white"
            enabled: true
            locations:
              GMT: "Etc/GMT"
              Berlin: "Europe/Berlin"
              Copenhagen: "Europe/Copenhagen"
            position:
              top: 0
              left: 0
              height: 1
              width: 1
            refreshInterval: 15
            sort: "alphabetical"

          americas_time:
            title: "Americas"
            type: clocks
            colors:
              rows:
                even: "lightblue"
                odd: "white"
            enabled: true
            locations:
              UTC: "Etc/UTC"
              New_York: "America/New_York"
              Sao_Paulo: "America/Sao_Paulo"
              Denver: "America/Denver"
              Chicago: "America/Chicago"
            position:
              top: 0
              left: 1
              height: 1
              width: 1
            refreshInterval: 15
            sort: "alphabetical"

          todolist:
            type: todo
            checkedIcon: "X"
            colors:
              checked: gray
              highlight:
                fore: "black"
                back: "orange"
            enabled: true
            filename: "todo.yml"
            position:
              top: 1
              left: 0
              height: 3
              width: 1
            refreshInterval: 3600

          news:
            type: hackernews
            title: "HackerNews"
            enabled: true
            numberOfStories: 10
            position:
              top: 0
              left: 2
              height: 1
              width: 5
            storyType: top
            refreshInterval: 900

          resources:
            type: resourceusage
            enabled: true
            position:
              top: 4
              left: 0
              height: 1
              width: 1
            refreshInterval: 1

          uptime:
            type: cmdrunner
            args: []
            cmd: "uptime"
            enabled: true
            position:
              top: 1
              left: 4
              height: 1
              width: 3
            refreshInterval: 30

          disks:
            type: cmdrunner
            cmd: "df"
            args: ["-h"]
            enabled: true
            position:
              top: 1
              left: 1
              height: 1
              width: 3
            refreshInterval: 3600

          urlcheck:
            enabled: true
            timeout: 25
            urls:
              - https://google.com # ok
              - https://instagram.com # ok
              - https://reddit.com # ok
              - https://github.com # ok
              - https://discord.com # ok
            position:
              top: 2
              left: 5
              height: 1
              width: 2
            refreshInterval: 30

          prettyweather:
            enabled: true
            city: "istanbul"
            position:
              top: 2
              left: 1
              height: 3
              width: 4
            refreshInterval: 5m
            unit: "m"
            view: 2
            language: "en"

          subreddit:
            enabled: true
            numberOfPosts: 20
            position:
              top: 3
              left: 5
              height: 2
              width: 2
            refreshInterval: 15m
            sortOrder: top
            subreddit: "unixporn"
            topTimePeriod: month
    '';
  };
}
