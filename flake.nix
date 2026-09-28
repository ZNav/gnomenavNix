{
  description = "HTB attack environment via nix-security-box";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-security-box.url = "github:fabaff/nix-security-box";
  };

  outputs = { self, nixpkgs, nix-security-box }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ];
      importPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      # Dev shells for each architecture
      devShells = forAllSystems (system:
        let
          pkgs = importPkgs system;
          
          # Pull tools from nix-security-box
          securityTools = with nix-security-box.packages.${system}; [
            nmap nsscan nikto sqlmap metasploit burpsuite
            hashcat john hydra impacket bloodhound
            chisel socat netcat python3 seclists
          ];
          
          htbSpecific = with pkgs; [
            openvpn wireguard-tools proxychains4
            pwntools go rust gobuster ffuf nuclei
          ];
          
        in {
          default = pkgs.mkShell {
            packages = securityTools ++ htbSpecific;
            shellHook = ''
              echo "🎯 HTB Nix Security Box ($(uname -m))"
              echo "   Wordlists: ${pkgs.seclists}/share/wordlists"
              echo "   Start VPN: source scripts/htb-connect.sh"
              export HTB_WORDLISTS="${pkgs.seclists}/share/wordlists"
              export PATH="$PWD/scripts:$PATH"
            '';
          };
          
          web = pkgs.mkShell {
            packages = with nix-security-box.packages.${system}; [ 
              nikto sqlmap burpsuite wpscan dirsearch
            ] ++ htbSpecific;
          };
          
          recon = pkgs.mkShell {
            packages = with nix-security-box.packages.${system}; [
              nmap masscan rustscan amass subfinder httpx
            ] ++ [ pkgs.ffuf pkgs.gobuster ];
          };
        });
    };
}
