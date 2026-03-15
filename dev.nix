{ pkgs, ... }: {
  channel = "stable-24.05";
  packages = with pkgs; [
    unzip
    openssh
    git
    qemu_kvm
    sudo
    cdrkit
    cloud-utils
    qemu
    wget
    curl
    lsof
  ];
  env = {
    EDITOR = "nano";
    VM_DIR = "$HOME/vms";
  };
  idx = {
    extensions = [ 
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];
    workspace = {
      onCreate = {
        "Setup VM Directory" = "mkdir -p ~/vms";
      };
      onStart = {
        "Check Dependencies" = "which qemu-system-x86_64 && echo 'QEMU ready'";
      };
    };
    previews = {
      enable = false;
    };
  };
}
