class Pow < Formula
  desc "Zero-config Rack server for local apps on macOS"
  homepage "http://pow.cx/"
  url "http://get.pow.cx/versions/0.5.0.tar.gz"
  sha256 "2e5f74d7c2f44004eb722eddf37356cd09b5563fde987b4c222fa6947ce388b7"

  bottle :unneeded

  depends_on "node"

  # Linux is not supported and the DNS handling rules only work on macOS
  # see https://github.com/basecamp/pow/wiki/FAQ#is-linux-supported
  depends_on :macos

  def install
    libexec.install Dir["*"]
    (bin/"pow").write <<~EOS
      #!/bin/sh
      export POW_BIN="#{bin}/pow"
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/lib/command.js" "$@"
    EOS
  end

  def caveats
    <<~EOS
      Create the required host directories:
        mkdir -p ~/Library/Application\\ Support/Pow/Hosts
        ln -s ~/Library/Application\\ Support/Pow/Hosts ~/.pow

      Setup port 80 forwarding and launchd agents:
        sudo pow --install-system
        pow --install-local

      Load launchd agents:
        sudo launchctl load -w /Library/LaunchDaemons/cx.pow.firewall.plist
        launchctl load -w ~/Library/LaunchAgents/cx.pow.powd.plist
    EOS
  end
end
