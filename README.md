OneMore Wanderers server
---

Install the server with:
```
nix run github:nix-community/nixos-anywhere -- --generate-hardware-config nixos-generate-config ./hardware-configuration.nix --flake .#onemore --target-host root@<ip>
```

To push changes run:
```
nixos-rebuild switch --flake .#onemore --ask-sudo-password --target-host server@<ip> 
```

In case the modpack is updated, run `nix flake update modpack` to update the input. Changing the `packHash` will be required.