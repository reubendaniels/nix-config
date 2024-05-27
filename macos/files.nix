# macOS-specific managed home directory files
{ configdir, ... }:

{
  "${configdir}/ssl/certs/sector42-ca.pem".source = ../common/config/sector42-ca.pem;
}
