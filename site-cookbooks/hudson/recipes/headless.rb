# This recipe was inspired by this post:
# http://blog.kabisa.nl/2010/05/24/headless-cucumbers-and-capybaras-with-selenium-and-hudson/
#
# To use this in your Hudson jobs you should do it like so:
#
# #!/bin/bash
# export DISPLAY=:99
# /etc/init.d/xvfb start
# rake cucumber
# RESULT=$?
# /etc/init.d/xvfb stop
# exit $RESULT

# this is used to find the firefox preference file, which is stored in a random directory
FIREFOX_PREFERENCES_FILE = %q{find /home/hudson/.mozilla/ -name "prefs.js"}.freeze

def add_firefox_preference(preference)
  script "add #{preference}" do
    interpreter "bash"
    user        "hudson"
    group       "hudson"
    cwd         "/home/hudson"
    not_if      %q{grep '#{preference}' `#{FIREFOX_PREFERENCES_FILE}`}
    code        <<-C
      echo '#{preference}' >> `#{FIREFOX_PREFERENCES_FILE}`
    C
  end
end

package "xvfb" do
  action :upgrade
end

template "/etc/init.d/xvfb" do
  owner  "hudson"
  mode   0700
  source "xvfb-init.erb"
end

package "firefox" do
  action :upgrade
end

# because of the way firefox generates its preference folder in a random location, 
# we have to start it up in order to modify the preferences.

script "generate mozilla prefs.js" do
  interpreter "bash"
  user        "hudson"
  group       "hudson"
  cwd         "/home/hudson"
  not_if      %q{test -d /home/hudson/.mozilla && test -f `#{FIREFOX_PREFERENCES_FILE}`}
  code        <<-C
    export DISPLAY=:99
    export HOME=/home/hudson
    echo 'Starting Xvfb'
    /etc/init.d/xvfb start
    echo 'Starting Firefox'
    firefox &
    sleep 10
    echo 'Killing Firefox'
    kill $(pidof firefox-bin)
    echo 'Stopping Xvfb'
    /etc/init.d/xvfb stop
  C
end

add_firefox_preference('user_pref("browser.sessionstore.enabled", false);')
add_firefox_preference('user_pref("browser.sessionstore.resume_from_crash", false);')
