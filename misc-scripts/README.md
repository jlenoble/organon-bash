# Miscellaneous scripts

## shutdown

Should be installed as root. Allows to limit the hours of activity of a computer by making
it unstartable before a min time and after a max time.

The script ensures the computer will be shut sdown at night and won't be restartable until
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
