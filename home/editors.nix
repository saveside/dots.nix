# Editors configuration (nixvim, zed, opencode)
{ pkgs, ... }:

{
  #############################################################################
  # Nixvim (Neovim)
  #############################################################################

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      clipboard = "unnamedplus";
      fillchars = {
        vert = " ";
        vertleft = " ";
        vertright = " ";
        verthoriz = " ";
      };
    };

    colorschemes.catppuccin.enable = true;

    keymaps = [
      {
        mode = "n";
        key = "<C-n>";
        action = "<cmd>Neotree toggle<CR>";
        options = {
          desc = "Toggle Neo-tree";
          silent = true;
        };
      }
    ];

    plugins = {
      # UI Elements
      lualine.enable = true;
      bufferline.enable = true;
      cursorline.enable = true;
      smear-cursor.enable = true;
      transparent = {
        enable = true;
        autoLoad = true;
      };

      # File Tree
      neo-tree = {
        enable = true;
        window.width = 32;
      };

      # Dashboard
      dashboard = {
        enable = true;
        settings = {
          theme = "doom";
          config = {
            header = [
              "=================      ===============      ===============   ========  ========"
              "\\\\ . . . . . . .\\\\    //. . . . . . .\\\\    //. . . . . . .\\\\  \\\\. . .\\\\// . . //"
              "||. . ._____. . .|| ||. . ._____. . .|| ||. . ._____. . .|| || . . .\\/ . . .||"
              "|| . .||   ||. . || || . .||   ||. . || || . .||   ||. . || ||. . . . . . . ||"
              "||. . ||   || . .|| ||. . ||   || . .|| ||. . ||   || . .|| || . | . . . . .||"
              "|| . .||   ||. _-|| ||-_ .||   ||. . || || . .||   ||. _-|| ||-_.|\\ . . . . ||"
              "||. . ||   ||-'  || ||  `-||   || . .|| ||. . ||   ||-'  || ||  `|\\_ . .|. .||"
              "|| . _||   ||    || ||    ||   ||_ . || || . _||   ||    || ||   |\\ `-_/| . ||"
              "||_-' ||  .|/    || ||    \\|.  || `-_|| ||_-'.|/  .||    || ||   | \\  / |-_.||"
              "||    ||_-'      || ||      `-_||    || ||    ||_-'      || ||   | \\  / |  `||"
              "||    `'          || ||          `'    || ||    `'          || ||   | \\  / |   ||"
              "||            .===' `===.          .==='.`===.          .===' /==. |  \\/  |   ||"
              "||         .=='   \\_|-_ `===. .==='   _|_   `===. .===' _-|/   `==  \\/  |   ||"
              "||      .=='    _-'    `-_  `='    _-'   `-_     `='  _-'   `-_  /|  \\/  |   ||"
              "||   .=='    _-'            `-_ _-'            `-_ _-'            `-_ |  \\/  |   ||"
              "||.=='    _-'                    `-'                    `-'                    `==.||"
              "`=='    _-'                                                                    `-_    `=='"
            ];
            center = [
              {
                icon = "  ";
                desc = "New File";
                action = "enew";
                key = "n";
              }
              {
                icon = "  ";
                desc = "Find File";
                action = "Telescope find_files";
                key = "f";
              }
              {
                icon = "󰈚  ";
                desc = "Recent Files";
                action = "Telescope oldfiles";
                key = "r";
              }
              {
                icon = "󰈭  ";
                desc = "Find Word";
                action = "Telescope live_grep";
                key = "g";
              }
              {
                icon = "  ";
                desc = "Quit";
                action = "qa";
                key = "q";
              }
            ];
            footer = [ "save's nixvim configuration" ];
          };
        };
      };

      # Navigation & Search
      telescope = {
        enable = true;
        keymaps = {
          "<leader>ff".action = "find_files";
          "<leader>fg".action = "live_grep";
          "<leader>fb".action = "buffers";
          "<leader>fh".action = "help_tags";
        };
      };

      # Terminal
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<M-i>]]";
          direction = "float";
          float_opts = {
            border = "rounded";
            winblend = 0;
          };
          start_in_insert = true;
          shade_terminals = true;
          persist_size = true;
          close_on_exit = true;
        };
      };

      # Treesitter
      treesitter = {
        enable = true;
        autoLoad = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };

      # Completion (nvim-cmp)
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          completion.completeopt = "menu,menuone,noinsert";
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require("luasnip").expand_or_jumpable() then
                  require("luasnip").expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
            "<S-Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                  require("luasnip").jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" })
            '';
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-buffer.enable = true;
      cmp-path.enable = true;
      cmp_luasnip.enable = true;

      # Snippets
      luasnip = {
        enable = true;
        fromVscode = [ { paths = [ "friendly-snippets" ]; } ];
      };
    };

    # LSP Configuration
    lsp = {
      servers = {
        clangd = {
          enable = true;
          config = {
            cmd = [
              "clangd"
              "--background-index"
            ];
            filetypes = [
              "c"
              "cpp"
            ];
          };
        };
        nixd.enable = true;
        lua_ls = {
          enable = true;
          settings.Lua = {
            diagnostics.globals = [ "vim" ];
            workspace.checkThirdParty = false;
          };
        };
      };
    };

    extraConfigLua = ''
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
      vim.diagnostic.config({ float = { border = "rounded" } })
    '';
  };

  #############################################################################
  # Zed Editor
  #############################################################################

  programs.zed-editor = {
    enable = true;
    extensions = [
      "material-icon-theme"
      "nix"
    ];
    extraPackages = with pkgs; [
      nixd
      nil
    ];
    userSettings = {
      telemetry = {
        metrics = false;
      };
      vim_mode = true;
    };
  };

  #############################################################################
  # OpenCode
  #############################################################################

}
