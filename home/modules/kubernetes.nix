# Kubernetes tools configuration (kubectl, k9s, krew, kubecolor)
{
  config,
  lib,
  pkgs,
  ...
}:

let
  krewCfg = config.programs.krew;
in
{
  #############################################################################
  # Krew Module (custom option)
  #############################################################################

  options.programs.krew = {
    enable = lib.mkEnableOption "Krew plugin manager";
    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of krew plugins to install via activation script.";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf krewCfg.enable {
      home.packages = [ pkgs.krew ];

      home.activation.installKrewPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        export PATH="${pkgs.krew}/bin:$PATH"
        
        $DRY_RUN_CMD krew update || true

        ${lib.concatMapStrings (plugin: ''
          echo "Ensuring krew plugin: ${plugin}"
          $DRY_RUN_CMD krew install "${plugin}" || true
        '') krewCfg.plugins}
      '';

      home.sessionPath = [ "$HOME/.krew/bin" ];
    })

    {
      programs.krew = {
        enable = true;
        plugins = [
          "rltop"
          "neat"
          "cnpg"
        ];
      };

      programs.k9s.enable = true;

      programs.kubecolor = {
        enable = true;
        enableAlias = true;
        enableZshIntegration = true;
      };

      programs.zsh.initContent = ''
        source <(kubectl completion zsh)
      '';

      home.packages = with pkgs; [
        kubernetes-helm
        kubectl
        kubeconform
        pluto
        kube-linter
      ];
    }
  ];
}
