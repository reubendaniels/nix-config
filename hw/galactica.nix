{hasGpu, ...}:

{
  hardware.opengl = {
    enable = hasGpu;
    driSupport = hasGpu;
    driSupport32Bit = hasGpu;
  };
}
