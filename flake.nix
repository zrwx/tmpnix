{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";  
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, impermanence, home-manager, ... }: {
    nixosConfigurations.u = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit (self) inputs outputs; };
      modules = [ ./nixos ];
    };
  };
}
