{ homedir, ... }:

{
  programs.git = {
    enable = true;
    userName = "ShellAddicted";
    userEmail = "shelladdicted@gmail.com";
    signing = {
      key = "shelladdicted@gmail.com";
      signByDefault = true;
    };
    ignores = [ "*.iml" ".idea/" ".vscode" ];
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit -s";
      cim = "commit -s -m";
      cin = "commit -s -n";
      st = "status";
      aa = "add .";
      a = "add";
      pl = "pull";
      l = "log --graph --name-status";
      ps = "push";
      psu = "push -u origin HEAD";
      psf = "push --force-with-lease";
      me = "merge";
    };
    lfs.enable = true;
    extraConfig = {
      commit = {
        template = "${homedir}/.config/git/message";
      };
      pull = {
        rebase = false;
      };
    };
  };

  xdg.configFile."git/message".source = ../configs/gitmessage;
}
