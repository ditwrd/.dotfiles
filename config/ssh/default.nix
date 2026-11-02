# One module per client. Joining a company = drop a new file here with its
# keys and hosts, then add it to the imports.
{
  imports = [
    ./personal.nix
    ./iqm.nix
    ./cube.nix
  ];
}
