# Host-specific variables for honeybee server
{ type, ... }:

{
  inherit type;

  # Server-specific variables can go here
  # No monitors needed for headless server
}
