{ config, lib, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    awscli2
    git-remote-codecommit
    #inputs.nixpkgs-old.legacyPackages."${pkgs.system}".git-remote-codecommit
    postman
  ];
 
  virtualisation.docker.enable = true;

}
