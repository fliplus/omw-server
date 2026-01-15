{ modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disko.nix

    ./minecraft.nix
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostId = "64e5e86d";

  nix.settings.require-sigs = false;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "onemore";

  environment.systemPackages = with pkgs; [
    git
    neovim
    tmux
  ];

  users.users.root.initialPassword = "password";

  users.users.server = {
    isNormalUser = true;
    extraGroups = [ "wheel" "minecraft" ];

    initialPassword = "password";

    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDK6sT0vxVFy8zgEN9VygE5ZSHri7gV4gcslaxawfaj9" ];
  };

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  system.stateVersion = "25.11";
}
