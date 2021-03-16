# Other configurations

## Hot how to load Tilix configurations

Tilix uses dconf to manage its configurations. Therefore you need to use it to load them
from the `tilix` file:

```bash
dconf load /com/gexperts/Tilix/ < tilix
```

## Apply synaptics configuration

Copy `70-synaptics.conf` to `/etc/X11/xorg.conf.d/`.
