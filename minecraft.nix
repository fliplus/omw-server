{ inputs, pkgs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.onemore-wanderers = {
      enable = true;
      enableReload = true;

      package = pkgs.fabricServers.fabric-1_21_11.override {
        loaderVersion = "0.18.4";
	      jre_headless = pkgs.javaPackages.compiler.temurin-bin.jre-25;
      };

      jvmOpts = let
        memory = "2G";
	      performance = "-XX:+UseZGC -XX:+UseCompactObjectHeaders";
      in "-Xms${memory} -Xmx${memory} ${performance}";
    };
  };
}
