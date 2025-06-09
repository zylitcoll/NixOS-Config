# users.nix yang sedikit lebih rapi
{ pkgs, username, ... }: {
  users = {
    mutableUsers = true;
    users."${username}" = {
      # homeMode = "755"; # DIHAPUS: Ini adalah default, tidak perlu didefinisikan.
      isNormalUser = true;
      description = "zylitcoll"; # Ganti dengan deskripsi statis
      extraGroups = [
        "networkmanager" "wheel" "libvirtd" "scanner" "lp" "video"
        "input" "audio" "docker" "storage" "plugdev"
      ];
      packages = with pkgs; [
        # Paket yang diinstal khusus untuk pengguna ini, jika ada.
      ];
    };
    defaultUserShell = pkgs.zsh;
  };

  # Menyediakan Zsh sebagai shell yang tersedia di sistem
  environment.shells = with pkgs; [ zsh ];
  
  # lsd dan fzf diperlukan oleh Zsh di bawah, jadi kita instal di sistem
  environment.systemPackages = with pkgs; [ lsd fzf ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "fox";
    };

    # Gunakan opsi history yang sudah ada, jangan di dalam promptInit
    history = {
      size = 10000;
      save = 10000;
      share = true; # Setara dengan 'setopt sharehistory'
      path = "$HOME/.zsh_history";
    };

    # promptInit sekarang sedikit lebih bersih
    promptInit = ''
      # Menjalankan fastfetch setiap kali terminal dibuka bisa memperlambat.
      # Pertimbangkan untuk memindahkannya ke ~/.zlogin atau menjalankannya manual.
      fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc

      # Alias untuk lsd
      alias ls='lsd'
      alias l='ls -l'
      alias la='ls -a'
      alias lla='ls -la'
      alias lt='ls --tree'

      # Inisialisasi fzf
      source <(fzf --zsh)
    '';
  };
}
