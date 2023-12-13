  {
    enable = true;

    settings = {
      font = let family = "Iosevka"; in {
        normal = {
          family = family;
          style = "Regular";
        };

        bold = {
          family = family;
          style = "Bold";
        };
      
        italic = {
          family = family;
          style = "Italic";
        };
      
        bold_italic = {
          family = family;
          style = "Bold Italic";
        };
      
        size = 12;

        offset = {
          x = 0;
          y = 1;
        };
      };
      
      colors = {
        primary = {
          background = "0xffffff";
          foreground = "0x586069";
        };
      
        normal = {
          black = "0x1d1f21";
          red = "0xd03d3d";
          green = "0x07962a";
          yellow = "0x949800";
          blue = "0x0451a5";
          magenta = "0xbc05bc";
          cyan = "0x0598bc";
          white = "0xffffff";
        };
      
        bright = {
          black = "0x666666";
          red = "0xcd3131";
          green = "0x14ce14";
          yellow = "0xb5ba00";
          blue = "0x0451a5";
          magenta = "0xbc05bc";
          cyan = "0x0598bc";
          white = "0x586069";
        };
      };
      
      window = {
        opacity = 1;
      };
      
      cursor = {
        style = {
          blinking = "Never";
        };
      };
      
      env = {
        TERM = "alacritty";
      };
    };
  }