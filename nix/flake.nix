{
  description = "Emacs development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux"; # или "aarch64-linux" / "x86_64-darwin" / "aarch64-darwin"
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          # Сам Emacs
          emacs

          # Полезные инструменты
          git
          ripgrep
          fd
          tree-sitter

          # Примеры LSP / инструментов (добавляй что нужно)
          # clang-tools          # clangd
          # gopls
          # pyright
          # nodePackages.typescript-language-server
          # nodePackages.prettier
          # ruff
          # rust-analyzer
        ];

        shellHook = ''
          echo "Emacs environment ready"
          echo "Запуск: emacs"
        '';
      };
    };
}
