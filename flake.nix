{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit (self) inputs outputs; };
      modules = [ ./nixos.nix ];
    };
  };
}
