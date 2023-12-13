{
  enable = true;
  # signing.signByDefault = true;

  extraConfig = {
    init = {
      defaultBranch = "main";
    };
  
    filter = {
      lfs = {
        smudge = "git-lfs smudge -- %f";
        process = "git-lfs filter-process";
        required = true;
        clean = "git-lfs clean -- %f";
      };
    };
  
    gpg = {
      format = "ssh";
      ssh = {
        allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  
    commit = {
      gpgsign = true;
    };
  
    credential = {
      helper = "libsecret";
      # from the wiki:
      # helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
    };
  
    log = {
      showSignature = true;
      abbrevCommit = "yes";
      date = "iso8601";
    };
  
    core = {
      abbrev = 8;
    };
  
    diff = {
      submodule = "log";
    };

    http = {
      postbuffer = 157286400;
    };
  };
}