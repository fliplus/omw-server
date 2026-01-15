{ inputs, lib, pkgs, ... }:
let
  modpack = pkgs.fetchPackwizModpack {
    src = "${inputs.modpack}";
    packHash = "sha256-m6qOXwp15iDP0tx72OZAUEVqDq+7KBoLicoeDx33Yuw=";
  };

  minecraftVersion = modpack.manifest.versions.minecraft;
  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${minecraftVersion}";
  fabricVersion = modpack.manifest.versions.fabric;
in
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

      package = pkgs.fabricServers.${serverVersion}.override {
        loaderVersion = fabricVersion;
	      jre_headless = pkgs.javaPackages.compiler.temurin-bin.jre-25;
      };

      jvmOpts = let
        memory = "2G";
	      performance = "-XX:+UseZGC -XX:+UseCompactObjectHeaders";
      in "-Xms${memory} -Xmx${memory} ${performance}";

      operators = {
        fliplus = "e0b16084-50c6-4a09-94ae-7cfa71b4055a";
      };

      symlinks = {
        "mods" = "${modpack}/mods";
      };

      files = {
        "config" = "${modpack}/config";
      };
    };
  };
}
