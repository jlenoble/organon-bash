# Miscellaneous scripts

## shutdown

Should be installed as root. Allows to limit the hours of activity of a computer by making
it unstartable before a min time and after a max time.

The script ensures the computer will be shut down at night and won't be restartable until
the next morning, ensuring no activity can take place outside wakeup time.

Requires to be used as a root '@reboot' crontab.

```bash
sudo mkdir -p /root/bin
sudo cp ./shutdown.sh /root/bin
sudo chmod 500 /root/bin/shutdown.sh
sudo crontab -e
```

```sh
# sudo crontab -e
@reboot /root/bin/shutdown.sh &
```

## hosts

Should be installed as root. Allows to limit the hours of access of particular websites by
redirecting them to the local loop between a min time and a max time.

The script ensures the computer forbids access to social media during work hours. When installed
the black list is empty. See [add-host](#add-hosts) to black-list a URL.

Requires to be used as a root '@reboot' crontab.

```bash
sudo mkdir -p /root/bin
sudo mkdir -p /root/etc
sudo cp ./hosts.sh /root/bin
sudo chmod 500 /root/bin/hosts.sh
sudo cp /etc/hosts /root/etc/hosts
sudo cp /etc/hosts /root/etc/hosts-head
sudo touch /root/etc/hosts-tail
sudo crontab -e
```

```sh
# sudo crontab -e
@reboot /root/bin/hosts.sh &
```

## add-host

Not a script, but a compiled c++ program.

Blacklists a URL. To be used in combination with [hosts](#hosts)

Can be run by anybody. Can only be undone by a sudoer.

```bash
g++ -std=c++17 ./c++/add-host.cpp -L/usr/lib/x86_64-linux-gnu -lstdc++fs -o add-host
mv add-host ~/bin
cd ~/bin
sudo chown root:root add-host
sudo chmod 4755 add-host
cd -
```

## toggle-block

Not a script, but a compiled c++ program. Requires libboost.

Block/unblock access to a strongly encrypted passwd file on the strongly encrypted SDD. By default, there are no sudoers on the computer and nobody, even myself, knows the superuser passwd, nor is it saved anywhere except in the blocked file on disk.

Unblocking requires at least 12 hours of uninterrupted running. Beware that [shutdown](#shutdown) defines a time span greater than the latter duration or the computer will be irrevocably blocked.

```bash
g++ -std=c++17  ./c++/toggle-block.cpp -I/usr/include/boost -L/usr/lib/x86_64-linux-gnu -lboost_system -lboost_thread -lpthread -o toggle-block
mv toggle-block ~/bin
cd ~/bin
sudo chown root:root toggle-block
sudo chmod 4755 toggle-block
cd -
```
