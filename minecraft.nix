{ inputs, lib, pkgs, ... }:
let
  modpack = pkgs.fetchPackwizModpack {
    src = "${inputs.modpack}";
    packHash = "sha256-DOi+KIYrhAkkCFN7EIFDflRSQgslbATonhoOEpvwGms=";
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

      symlinks = {
        "mods" = "${modpack}/mods";
      };

      files = {
        "config" = "${modpack}/config";
      };

      operators = {
        fliplus = "e0b16084-50c6-4a09-94ae-7cfa71b4055a";
      };

      serverProperties = {
        difficulty = "hard";
        initial-enabled-packs = "vanilla,minecart_improvements";
        max-players = 69;
        motd = "Now out!";
        simulation-distance = 8;
        spawn-protection = 0;
        sync-chunk-writes = false;
        view-distance = 10;
      };
    };
  };
}
