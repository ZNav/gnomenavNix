# Tool set for Pentesting

This package set for NixOS contains some tools to perform penetration
tests, security assessments and other tasks related to information security.

There are already a bunch of expressions available which try to follow Kali
Linux. The approach here is more based on the actual need for different tools
than to follow other distributions and try to mimic them.

The focus is on the combination of well-known tools with brand-new one. While skipping
unmaintained ones.

## Usage

Make the repo available on your machine and include the category/files you want in `/etc/nixos/configuration.nix`. See "[imports](https://fabaff.github.io/nix-security-box/imports)" for all available categories.

```nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/intel/nuc/8i7beh>
      ./hardware-configuration.nix
      ./port-scanners.nix
    ];
[...]
```

Or cherry-pick the tools you want and create a new [shell](https://nixos.wiki/wiki/Development_environment_with_nix-shell). E.g., `portscan.nix`:

```nix
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  nativeBuildInputs = [
    nmap
    masscan
  ];
}
```

```bash
$ nix-shell portscan.nix
````

Or use this [template](https://fabaff.github.io/nix-security-box/nstb-shell.nix) and delete the tools you don't need. Also, it's recommaneded to check out [RedNix](https://github.com/redcode-labs/RedNix) where you can find ready-to-use shells.

## License

Everything here is licensed under MIT.

FORKED :p

# 🎯 HTB Nix Security Box

Reproducible penetration testing environment using nix-security-box. Drop into any terminal, get full HTB toolkit with pinned versions. No VMs, no drift, no setup time.

## Quick Start

```bash
# Clone
git clone https://github.com/ZNav/htb-nix-security-box
cd htb-nix-security-box

# Load full arsenal (15 seconds)
nix develop

# Or specific focus
nix develop .#web     # Web app attacks
nix develop .#recon   # Reconnaissance only

Features
Feature	Benefit
Declarative	Same tools, same versions, every time
Multi-arch	Works on x86_64 (MSI) + aarch64 (M2 Mac)
No VM overhead	Native tools, no emulation penalty
Pinned deps	flake.lock guarantees reproducibility
HTB-optimized	VPN wrapper, target helpers, scan templates
Tool Categories
Recon: nmap, masscan, amass, subfinder, nuclei
Web: burpsuite, sqlmap, nikto, ffuf, gobuster
Exploit: metasploit, impacket, crackmapexec
Passwords: hashcat, john, hydra, seclists
Post-exploit: chisel, socat, evil-winrm
Architecture Support
Machine	Arch	Command
MSI 15 Delta	x86_64	nix develop
MacBook Air M2	aarch64	nix develop
Getting HTB VPN Files
Download .ovpn files from HackTheBox dashboard
Create ~/.htb/vpn/ directory
Place .ovpn files there
Create ~/.htb/vpn/creds with your HTB credentials
Run: ./scripts/htb-connect.sh lab
Workflow Example
# 1. Load tools
nix develop

# 2. Connect to HTB
source scripts/htb-connect.sh lab

# 3. Add target to hosts
./scripts/htb-target.sh 10.10.11.123 sillycat.htb

# 4. Scan
./scripts/htb-scan.sh 10.10.11.123

# 5. Investigate
sqlmap -u "http://sillycat.htb/index.php?id=1" --batch

Contributing
Found a missing tool? Open an issue or submit a PR adding it to flake.nix.

License
MIT — Fork, modify, adapt freely.


---
