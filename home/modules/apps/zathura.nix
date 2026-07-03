{...}:

{
  programs.zathura = {
  enable = true;
  options = {
    # Notification colors
    "notification-error-bg" = "#ffb4ab";
    "notification-error-fg" = "#690005";
    "notification-warning-bg" = "#ffb86c";
    "notification-warning-fg" = "#44475a";
    "notification-bg" = "#22191a";
    "notification-fg" = "#d7c1c3";

    # Completion and Index
    "completion-bg" = "#22191a";
    "completion-fg" = "#d7c1c3";
    "completion-group-bg" = "#ffb2bb";
    "completion-group-fg" = "#561d28";
    "completion-highlight-bg" = "#e5bdc0";
    "completion-highlight-fg" = "#43292d";

    "index-bg" = "#1a1112";
    "index-fg" = "#d7c1c3";
    "index-active-bg" = "#ffb2bb";
    "index-active-fg" = "#561d28";

    # UI Elements
    "inputbar-bg" = "#22191a";
    "inputbar-fg" = "#d7c1c3";
    "statusbar-bg" = "#22191a";
    "statusbar-fg" = "#d7c1c3";

    # Highlights & Rendering
    "highlight-fg" = "rgba(240,222,223,1.0)";
    "highlight-active-color" = "rgba(255,191,143,0.5)";
    "highlight-color" = "rgba(233,180,171,0.5)";

    "default-bg" = "#1a1112";
    "default-fg" = "#d7c1c3";

    "render-loading" = true;
    "render-loading-fg" = "#1a1112";
    "render-loading-bg" = "#d7c1c3";

    # Recolor
    "recolor" = true;
    "recolor-lightcolor" = "#1a1112";
    "recolor-darkcolor" = "#d7c1c3";

    # Custom Settings
    "window-title-home-tilde" = true;
    "statusbar-basename" = true;
    "selection-clipboard" = "clipboard";
    "adjust-open" = "width";
    "guioptions" = "";
    "first-page-column" = "1:2";
  };
  
  # Map your keys
  extraConfig = ''
    map j feedkeys "<C-Down>"
    map k feedkeys "<C-Up>"
  '';
};
}
