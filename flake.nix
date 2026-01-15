{
  description = "OneMore Wanderers minecraft server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    modpack = {
      url = "git+ssh://git@github.com/fliplus/omw-server-modpack";
      flake = false;
    };
  };

  outputs = { nixpkgs, ... } @ inputs: {

    nixosConfigurations.onemore = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        inputs.disko.nixosModules.disko
        ./configuration.nix
      ];
    };

  };
}
