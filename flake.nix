{
  description = "HTB attack environment - reproducible multi-arch";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ];
      importPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      devShells = forAllSystems (system:
        let
          pkgs = importPkgs system;
          
          # START MINIMAL - verified working on aarch64-darwin
          tools = with pkgs; [
            # Networking/Recon (most likely to work)
            nmap
            ffuf
            gobuster
            
            # Scripting
            python3 python3Packages.python-lsp-server
            
            # Utilities
            git jq curl wget openssl socat
            
            # Compiled tools
            go rustc cargo
          ];
          
          # Linux-only tools
          linuxTools = if system == "x86_64-linux" then
            [ pkgs.metasploit-framework pkgs.hashcat pkgs.hydra pkgs.john ]
          else [];
          
        in {
          default = pkgs.mkShell {
            packages = tools ++ linuxTools;
            shellHook = ''
              echo "🎯 HTB Nix Security Box (${system})"
              export PATH="$PWD/scripts:$PATH"
            '';
          };
          
          recon = pkgs.mkShell {
            packages = with pkgs; [ nmap ffuf gobuster ];
          };
        });
    };
}
