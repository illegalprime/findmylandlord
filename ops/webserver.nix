{
  network.description = "Find My Landlord";

  main = { config, pkgs, modulesPath, ... }: {
    # the hetzner target
    deployment.targetHost = "5.161.215.203";

    imports = [
      (modulesPath + "/profiles/qemu-guest.nix")
      ../pkg/module.nix
    ];

    services.findmylandlord.virtualhost = "organizethis.gbtu.xyz";

    # start the reverse proxy
    services.nginx.enable = true;
    security.acme.acceptTerms = true;
    security.acme.defaults.email = "themichaeleden@gmail.com";

    # app secrets
    deployment.keys.findmylandlord= {
      text = builtins.readFile ./secrets/app;
    };

    # firewall
    networking.firewall.allowedTCPPorts = [ 22 80 443 ];

    # we're booting
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.devices = [ "/dev/sda" ];
    boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sd_mod" "sr_mod"];
    fileSystems."/" = {
      device = "/dev/disk/by-uuid/cf27e80b-f418-472e-8846-36073a76a628";
      fsType = "ext4";
    };
    swapDevices = [ { device = "/swapfile"; size = 2048; } ];

    # firmware
    hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;

    # Define your hostname.
    networking.hostName = "find-my-ll";

    # Set your time zone.
    time.timeZone = "America/New_York";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    # networking
    networking.interfaces.enp1s0.useDHCP = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.admin = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
    services.openssh.permitRootLogin = "prohibit-password";
  };
}
